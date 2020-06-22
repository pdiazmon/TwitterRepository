//
//  Mention.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 19/06/2020.
//

import Foundation
import Vapor
import FluentSQLite

struct Mention: Content, SQLiteModel {
	typealias Database = SQLiteDatabase
	
	var id: Int?
	
	var tweet_id: String
	var created_at: String
	var text: String
}

extension Mention: Migration {

	static func prepare(on connection: SQLiteConnection) -> Future<Void> {
    
		return Database.create(self, on: connection) { (builder) in
            try addProperties(to: builder)
            builder.unique(on: \.tweet_id)
        }
    }
}

extension Mention {
	
	static func create(tweet: MentionTweet) -> Self {
		return Mention(tweet_id: tweet.id_str, created_at: tweet.created_at, text: tweet.text)
	}
}


