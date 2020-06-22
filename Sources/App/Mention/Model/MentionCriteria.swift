//
//  MentionCriteria.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 04/06/2020.
//

import Foundation
import Vapor
import FluentSQLite

struct MentionCriteria: Content, SQLiteModel {
	typealias Database = SQLiteDatabase
	
	var id: Int?
	
	var user: String
	var created: Date?
	
	static let createdAtKey: TimestampKey? = \.created
}

extension MentionCriteria: Migration {
	
	static func prepare(on connection: SQLiteConnection) -> Future<Void> {
		
		return Database.create(self, on: connection) { (builder) in
			try addProperties(to: builder)
			builder.unique(on: \.user)
		}
	}
}

extension MentionCriteria: Validatable {
	
	static func validations() throws -> Validations<MentionCriteria> {

		var validations = Validations(MentionCriteria.self)
		
		validations.add(\.user, at: ["user"], .count(1...))
		validations.add(\.id, at: ["id"], .range(1...) || .nil)

        return validations
    }
}
