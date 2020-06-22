//
//  MentionTweetsRepositoryProtocol.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 19/06/2020.
//

import Foundation
import Vapor

protocol MentionTweetsRepositoryProtocol {
	
	var container: Container { get set }
	
	func getMentionTweets(for user: String, last: String?) throws -> Future<[MentionTweet]>
}
