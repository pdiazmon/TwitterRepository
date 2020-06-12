//
//  Criteria.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 04/06/2020.
//

import Foundation
import Vapor
import FluentSQLite

struct Criteria: Content, SQLiteModel {
	typealias Database = SQLiteDatabase
	
	var id: Int?
	
	var criteria: String
	var created: Date?
	
	static let createdAtKey: TimestampKey? = \.created
}

//extension Criteria: SQLiteMigration {}
extension Criteria: Migration {}

extension Criteria: Validatable {
	
	static func validations() throws -> Validations<Criteria> {

		var validations = Validations(Criteria.self)
		
		validations.add(\.criteria, at: ["criteria"], .count(1...))
		validations.add(\.id, at: ["id"], .range(1...) || .nil)

        return validations
    }
}
