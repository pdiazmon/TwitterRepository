//
//  FollowersRepositoryMock.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 10/06/2020.
//

import Foundation
import Vapor
@testable import App

public class FollowersRepositoryMock: FollowersRepositoryProtocol {
	
	internal var container: Container
	
	init(_ container: Container) {
		self.container = container
	}
	
	static var followers: [Follower] = {
		
		return [Follower(id: 1, screen_name: "Follower1"),
				Follower(id: 2, screen_name: "Follower2"),
				Follower(id: 3, screen_name: "Follower3"),
				Follower(id: 4, screen_name: "Follower4"),
				Follower(id: 5, screen_name: "Follower5"),
				Follower(id: 6, screen_name: "Follower6")
			   ]
	}()
	
	public func getFollowers(of screen_name: String) throws -> EventLoopFuture<[Follower]> {
		let promise = container.eventLoop.newPromise(of: [Follower].self)
				
		promise.succeed(result: FollowersRepositoryMock.followers)
		
		return promise.futureResult
	}
}

extension FollowersRepositoryMock: Service {}
