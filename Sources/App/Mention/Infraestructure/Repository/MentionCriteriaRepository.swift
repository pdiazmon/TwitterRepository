//
//  MentionCriteriaRepository.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 09/06/2020.
//

import Foundation
import Vapor

class MentionCriteriaRepository: MentionCriteriaRepositoryProtocol {

	internal var container: Container
	
	enum MentionCriteriaRepositoryError: Error {
		case DuplicatedKey
	}
	
	init(_ container: Container) {
		self.container = container
	}
	
	func save(_ mentionCriteria: MentionCriteria) throws -> Future<MentionCriteria> {
		
		return container.withPooledConnection(to: .sqlite) { conn in
			return mentionCriteria.save(on: conn).catchMap { error in
				if (error.isDuplicatedKey()) {
				
					let logger = try self.container.make(CustomLogger.self)
					logger.warning("Existing mention criteria not saved: \(mentionCriteria.user)")
					
					return mentionCriteria
				}
				else {
					throw error
				}
			}
		}
	}
	
	func all() throws -> Future<[MentionCriteria]> {
		
		return container.withPooledConnection(to: .sqlite) { conn in
			return MentionCriteria.query(on: conn).all()
		}
	}
}

extension MentionCriteriaRepository: ServiceType {
    /// See `ServiceType`.
	public static var serviceSupports: [Any.Type] {
        return [MentionCriteriaRepositoryProtocol.self]
    }

    /// See `ServiceType`.
	public static func makeService(for worker: Container) throws -> Self {
		return MentionCriteriaRepository(worker) as! Self
    }
}
