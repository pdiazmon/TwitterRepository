//
//  FollowersRepository.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 09/06/2020.
//

import Foundation
import Vapor

class FollowersRepository: TwitterRepository { }
 
extension FollowersRepository: FollowersRepositoryProtocol {
	
	func getFollowers(of screen_name: String) throws -> Future<[Follower]> {
		
		let followersQueries: TwitterQueries = ["include_user_entities": "false",
												"skip_status":           "true",
												"screen_name":           screen_name]
		
		return try self.newRequest(container, endpoint: .followers, queries: followersQueries).flatMap(to: [Follower].self) { resp in

			// Once the information is received from Twitter, decode and return it
			return try resp.content.decode(FollowersResponse.self)
						.map { followers in
							return followers.users
						}
		}
	}
}

extension FollowersRepository: ServiceType {
    /// See `ServiceType`.
	public static var serviceSupports: [Any.Type] {
        return [FollowersRepositoryProtocol.self]
    }

    /// See `ServiceType`.
	public static func makeService(for worker: Container) throws -> Self {
		return FollowersRepository(worker) as! Self
    }
}
