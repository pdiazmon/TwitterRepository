//
//  MentionController.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 09/06/2020.
//

import Foundation
import Vapor

class MentionController: RouteCollection {
	
	func boot(router: Router) throws {
		
		router.group("mention") { (mentionGroup) in
			mentionGroup.group("criteria") { criteriaGroup in
				criteriaGroup.post(MentionCriteria.self, at: "add", use: self.addNewMentionCriteria)
				criteriaGroup.get("all", use: self.getAllMentionsCriteria)
			}
			
			mentionGroup.group("tweets") { tweetsGroup in
				tweetsGroup.get("all", use: self.getAllMentionTweets)
			}
		}
	}
}

extension MentionController {
	
	func addNewMentionCriteria(_ req: Request, newMC: MentionCriteria) throws -> Future<MentionCriteria> {

		let action = MentionCriteriaAction()
		let logger = try req.make(CustomLogger.self)
		
		let mentionCriteriaRepository = try req.make(MentionCriteriaRepositoryProtocol.self)

		try newMC.validate()

		return try action.addNewMentionAction(newMC, logger: logger, on: mentionCriteriaRepository)
		.map { newCriteria in
			logger.info("New mention criteria added: \(newCriteria.user)")
			return newCriteria
		}
	}
	
	func getAllMentionsCriteria(_ container: Container) throws -> Future<[MentionCriteria]> {
		
		let action = MentionCriteriaAction()

		let mentionCriteriaRepository = try container.make(MentionCriteriaRepositoryProtocol.self)

		return try action.getAllStoredMentionCriteriasAction(from: mentionCriteriaRepository)
	}
	
	func getAllMentionTweets(_ container: Container) throws -> Future<[Mention]> {
		
		let action = MentionAction()

		let mentionRepository = try container.make(MentionRepositoryProtocol.self)
		
		return try action.getAllStoredMentions(on: mentionRepository)
	}
	
}
