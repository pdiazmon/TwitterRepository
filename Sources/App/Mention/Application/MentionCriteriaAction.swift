//
//  MentionCriteriaAction.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 09/06/2020.
//

import Foundation
import Vapor

class MentionCriteriaAction {
	
	func addNewMentionAction(_ mentionToAdd: MentionCriteria, logger: Logger, on repository: MentionCriteriaRepositoryProtocol) throws -> Future<MentionCriteria> {
		return try repository.save(mentionToAdd)
	}

	@discardableResult
	func getAllStoredMentionCriteriasAction(from repository: MentionCriteriaRepositoryProtocol) throws -> Future<[MentionCriteria]> {
		return try repository.all()
	}
}
