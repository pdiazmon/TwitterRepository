//
//  FollowersController.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 09/06/2020.
//

import Foundation
import Vapor

class FollowersController: RouteCollection {
	
	private var repository: FollowersRepositoryProtocol
	
	init(repository: FollowersRepositoryProtocol) {
		self.repository = repository
	}
	
	func boot(router: Router) throws {
		
		router.group("followers") { (group) in
			group.get("", use: self.getFollowers)
		}
	}
}

extension FollowersController {
	
	enum FollwerError: Error {
		case emptyUser
	}
	
	func getFollowers(_ req: Request) throws -> Future<[Follower]> {
		
		let action = FollowersAction()
		self.repository.req = req
		
		return try req.content.decode(FollowersRequest.self).flatMap { followersRequest in
			
			try followersRequest.validate()
			
			return try action.getFollowers(by: followersRequest.screen_name, using: self.repository)
		}
	}
}
