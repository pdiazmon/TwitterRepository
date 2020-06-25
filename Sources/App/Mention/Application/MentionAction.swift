//
//  MentionAction.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 19/06/2020.
//

import Foundation
import Vapor

class MentionAction {
	
	func addNewMention(_ mention: Mention, on repository: MentionRepositoryProtocol) throws -> Future<Mention> {
		return try repository.save(mention)
	}
	
	func getAllStoredMentions(on repository: MentionRepositoryProtocol) throws -> Future<[Mention]> {
		return try repository.all()
	}
	
	func purgeOlder(than days: Int, on repository: MentionRepositoryProtocol, completion: @escaping (Int) throws -> Void) throws {
		
		let _ = try repository.purgeOlder(than: days).map { numberOfDeletedRows in
			try completion(numberOfDeletedRows)
		}
	}
	
}
