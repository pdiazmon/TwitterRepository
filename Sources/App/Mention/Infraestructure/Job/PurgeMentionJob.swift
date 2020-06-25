//
//  PurgeMentionJob.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 24/06/2020.
//

import Foundation
import Vapor

class PurgeMentionJob: JobProtocol {
	private var name: String?
	
	private var mentionRepository: MentionRepositoryProtocol
	
	init(_ container: Container) throws {
		self.mentionRepository = try container.make(MentionRepositoryProtocol.self)
	}

	
	func run(container: Container) throws {
		let config = try container.make(AppConfigProtocol.self)
		
		let mentionAction = MentionAction()
		
		try mentionAction.purgeOlder(than: config.readConfig(MentionJobConfig.self)?.mention_config.purge_before_days ?? 1000,
									  on: self.mentionRepository)
		{ mentionsPurged in
			let logger = try container.make(CustomLogger.self)
			logger.info("  \(mentionsPurged) purged")
		}
	}
	
	func setName(_ name: String) {
		self.name = name
	}
	
	func getName() -> String {
		return self.name ?? ""
	}
	
	
}
