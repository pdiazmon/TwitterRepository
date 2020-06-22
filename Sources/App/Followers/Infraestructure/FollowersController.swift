//
//  FollowersController.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 09/06/2020.
//

import Foundation
import Vapor

class FollowersController: RouteCollection {
	
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
		
		let action           = FollowersAction()
		let repository       = try req.make(FollowersRepositoryProtocol.self)
		let followersRequest = try req.query.decode(FollowersRequest.self)

		try followersRequest.validate()
		
		return try action.getFollowers(by: followersRequest.screen_name, using: repository)
	}
}
