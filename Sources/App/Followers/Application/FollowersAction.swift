//
//  FollowersAction.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 09/06/2020.
//

import Foundation
import Vapor

class FollowersAction {
	
	func getFollowers(by screen_name: String, using repository: FollowersRepositoryProtocol) throws -> Future<[Follower]> {
		
		// Request the followers to the Twitter end-point
		return try repository.getFollowers(of: screen_name)
	}

}
