//
//  MentionTweetsRepositoryMock.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 21/06/2020.
//

import Foundation
import Vapor
@testable import App

class MentionTweetsRepositoryMock: MentionTweetsRepositoryProtocol {
	
	internal var container: Container
	
	init(_ container: Container) {
		self.container = container
	}
	
	static var mentionTweets: [MentionTweet] = {
		
		return [MentionTweet(created_at: "", id_str: "1", text: "tweet 1"),
				MentionTweet(created_at: "", id_str: "2", text: "tweet 2"),
				MentionTweet(created_at: "", id_str: "3", text: "tweet 3"),
				MentionTweet(created_at: "", id_str: "4", text: "tweet 4"),
				MentionTweet(created_at: "", id_str: "5", text: "tweet 5"),
				]
	}()

	
	func getMentionTweets(for user: String, last: String?) throws -> EventLoopFuture<[MentionTweet]> {
		let promise = container.eventLoop.newPromise(of: [MentionTweet].self)
		promise.succeed(result: MentionTweetsRepositoryMock.mentionTweets)
		return promise.futureResult
	}
}

extension MentionTweetsRepositoryMock: Service {}
