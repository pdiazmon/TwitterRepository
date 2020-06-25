//
//  MentionRepositoryProtocol.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 19/06/2020.
//

import Foundation
import Vapor

protocol MentionRepositoryProtocol {

	var container: Container { get set }

	func save(_ mention: Mention) throws -> Future<Mention>
	
	func all() throws -> Future<[Mention]>
	
	func purgeOlder(than days: Int) throws -> Future<Int>
}
