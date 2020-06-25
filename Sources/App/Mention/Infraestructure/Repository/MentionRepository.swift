//
//  MentionRepository.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 19/06/2020.
//

import Foundation
import Vapor
import Fluent

class MentionRepository: MentionRepositoryProtocol {

	internal var container: Container
	
	enum MentionRepositoryError: Error {
		case ContainerNotSet
	}
	
	init(_ container: Container) {
		self.container = container
	}
	
	func save(_ mention: Mention) throws -> Future<Mention> {
		
		return container.withPooledConnection(to: .sqlite) { conn in
			return mention.save(on: conn)
		}
	}
	
	func all() throws -> Future<[Mention]> {
		
		return container.withPooledConnection(to: .sqlite) { conn in
			return Mention.query(on: conn).all().map { mentions in
				return mentions.sorted { (Int($0.tweet_id) ?? 0) <  (Int($1.tweet_id) ?? 0)}
			}
		}
	}
	
	func purgeOlder(than days: Int) throws -> Future<Int> {

		return container.withPooledConnection(to: .sqlite) { conn -> Future<Int> in
			let compareDate = Calendar.current.date(byAdding: .day, value: -days, to: Date())
			
			return Mention.query(on: conn).all()
			.map { mentions in
				return mentions.filter { mention in
					guard let created_at = mention.created_at.toTwitterDate() else { return false }
					guard let compareDate = compareDate else { return false }
					
					return created_at < compareDate
				}
			}
			.map { filteredMentions in
				
				let number = filteredMentions.count
				
				filteredMentions.forEach { mention in
					let _ = mention.delete(on: conn)
				}
				
				return number
			}
		}
	}
}

extension MentionRepository: ServiceType {
    /// See `ServiceType`.
	public static var serviceSupports: [Any.Type] {
        return [MentionRepositoryProtocol.self]
    }

    /// See `ServiceType`.
	public static func makeService(for worker: Container) throws -> Self {
		return MentionRepository(worker) as! Self
    }
}
