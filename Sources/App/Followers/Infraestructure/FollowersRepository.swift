//
//  FollowersRepository.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 09/06/2020.
//

import Foundation
import Vapor

class FollowersRepository: TwitterRepository {}

extension FollowersRepository: FollowersRepositoryProtocol {
	
	func getFollowers(of screen_name: String) throws -> Future<[Follower]> {
		
		let followersQueries: TwitterQueries = ["include_user_entities": "false",
												"skip_status":           "true",
												"screen_name":           screen_name]
		
		return try self.newRequest(self.req!, endpoint: .followers, queries: followersQueries).flatMap(to: [Follower].self) { resp in

			// Once the information is received from Twitter, decode and return it
			return try resp.content.decode(FollowersResponse.self)
						.map(to:[Follower].self) { followers in
							return followers.users
						}
						.do { followers in
							print("Followers: \(followers.count)")
							
							for user in followers.sorted { $0.screen_name < $1.screen_name } {
								print(" ->\(user.screen_name):")
								print("       \(user.name)")
								print("       \(user.description)")
							}
						}
		}
	}

}
