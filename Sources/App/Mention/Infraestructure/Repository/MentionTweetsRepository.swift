//
//  MentionTweetsRepository.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 19/06/2020.
//

import Foundation
import Vapor

class MentionTweetsRepository: TwitterRepository {}

extension MentionTweetsRepository: MentionTweetsRepositoryProtocol {
	
	@discardableResult
	func getMentionTweets(for user: String, last: String?) throws -> Future<[MentionTweet]> {
		
		let logger = try container.make(CustomLogger.self)
		
		let tweetsQueries: TwitterQueries = ["q": "@\(user)",
											 "result_type": "recent",
											 "count": "100",
											 "since_id": last ?? "",
											 "include_entities": "false"]
		
		return try self.newRequest(container, endpoint: .search, queries: tweetsQueries).flatMap(to: [MentionTweet].self) { resp in

			// Once the information is received from Twitter, decode and return it
			return try resp.content.decode(MentionTweetsResponse.self)
				        .map(to: [MentionTweet].self) { tweetResponse in
							return tweetResponse.statuses
			            }
						.do { tweets in
							logger.info("Tweets with mention to \(user) received: \(tweets.count)")
						}
		}
	}
}

extension MentionTweetsRepository: Service {}
