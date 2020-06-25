//
//  MentionJob.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 18/06/2020.
//

import Foundation
import Vapor
import Mailgun

class MentionJob: JobProtocol {
	
	private var tweetsRepository: MentionTweetsRepositoryProtocol
	private var mentionCriteriaRepository: MentionCriteriaRepositoryProtocol
	private var mentionRepository: MentionRepositoryProtocol
	private var mailRepository: MailRepositoryProtocol
	
	private var name: String?
	
	private var lastMentionTweet: [String: String] = [:]

	init(_ container: Container) throws {
		self.tweetsRepository          = try container.make(MentionTweetsRepositoryProtocol.self)
		self.mentionCriteriaRepository = try container.make(MentionCriteriaRepositoryProtocol.self)
		self.mentionRepository         = try container.make(MentionRepositoryProtocol.self)
		self.mailRepository            = try container.make(MailRepositoryProtocol.self)
	}
	
	func setName(_ name: String) {
		self.name = name
	}
	
	func getName() -> String {
		return self.name ?? ""
	}
	
	func run(container: Container) throws {
		
		let criteriaAction = MentionCriteriaAction()

		try criteriaAction.getAllStoredMentionCriteriasAction(from: self.mentionCriteriaRepository).map { mentionCriterias in

			let mentionAction = MentionAction()
			
			try mentionCriterias.forEach { mention in
				
				try self.tweetsRepository.getMentionTweets(for: mention.user, last: self.lastMentionTweet[mention.user]).map(to: Void.self) { tweets in
					try tweets.forEach { tweet in
						let _ = try mentionAction.addNewMention(Mention.create(tweet: tweet), on: self.mentionRepository)
					}
					
					if (tweets.count > 0) {
						self.lastMentionTweet[mention.user] = tweets.map { Int($0.id_str) ?? 0 }.sorted { $0 < $1 }.last.map { "\($0)" }
						
						try self.sendEmailNotification(mention: mention, tweets: tweets)
					}
					
				}
			}
		}
	}
}

extension MentionJob {
	
	private func sendEmailNotification(mention: MentionCriteria, tweets: [MentionTweet]) throws {
		
		try self.mailRepository.sendMailNotification(subject: "TwitterRepository Test",
													 text: "New mentions",
													 html: "<h1>There are \(tweets.count) new mentions for \(mention.user)</h1>")
		
	}
}
