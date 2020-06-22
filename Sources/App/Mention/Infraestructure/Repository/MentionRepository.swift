//
//  MentionRepository.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 19/06/2020.
//

import Foundation
import Vapor

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
}

extension MentionRepository: Service {}
