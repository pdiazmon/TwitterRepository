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
	
	func getFollowers(_ req: Request) throws -> Future<[Follower]> {
		
		let action              = FollowersAction()
		let followersRepository = FollowersRepository(req)
		
		// Decode the input JSON request
		let followersRequest = try req.query.decode(FollowersRequest.self)
		
		return try action.getFollowers(by: followersRequest.screen_name, using: followersRepository)
	}
}
