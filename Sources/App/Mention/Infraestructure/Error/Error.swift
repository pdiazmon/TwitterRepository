//
//  Error.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 21/06/2020.
//

import Foundation
import FluentSQLite

extension Error {
	
	func isDuplicatedKey() -> Bool {
		return (self is SQLiteError) &&
		       (self as! SQLiteError).identifier == "constraint" &&
		       (self as! SQLiteError).reason.hasPrefix("UNIQUE constraint failed")
	}
}
