//
//  MentionTweetsResponse.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 19/06/2020.
//

import Foundation
import Vapor

struct MentionTweetsResponse: Content {
	var statuses: [MentionTweet]
}

struct MentionTweet: Content {
	var created_at: String
	var id_str: String
	var text: String
}
