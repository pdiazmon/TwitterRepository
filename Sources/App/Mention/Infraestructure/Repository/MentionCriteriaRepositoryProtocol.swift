//
//  MentionCriteriaRepositoryProtocol.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 09/06/2020.
//

import Foundation
import Vapor

protocol MentionCriteriaRepositoryProtocol {

	var container: Container { get set }

	func save(_ mentionCriteria: MentionCriteria) throws -> Future<MentionCriteria>
	
	func all() throws -> Future<[MentionCriteria]>
}
