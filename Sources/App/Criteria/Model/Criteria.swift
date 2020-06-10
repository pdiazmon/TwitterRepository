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
	
	var criteria: String?
	var created: Date?
	
	static let createdAtKey: TimestampKey? = \.created
}

//extension Criteria: SQLiteMigration {}
extension Criteria: Migration {}
