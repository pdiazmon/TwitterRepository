//
//  MentionRepositoryMock.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 21/06/2020.
//

import Foundation
import Vapor

class MentionRepositoryMock: MentionRepositoryProtocol {
	
	internal var container: Container
	
	private var mentions: [Mention] = []
	
	init(_ container: Container) {
		self.container = container
	}
	
	func save(_ mention: Mention) throws -> EventLoopFuture<Mention> {
		let promise = container.eventLoop.newPromise(of: Mention.self)
		
		self.mentions.append(mention)
		
		promise.succeed(result: mention)
		
		return promise.futureResult

	}
	
	func all() throws -> EventLoopFuture<[Mention]> {
		let promise = container.eventLoop.newPromise(of: [Mention].self)
				
		promise.succeed(result: self.mentions)
		
		return promise.futureResult

	}
}

extension MentionRepositoryMock: Service {}
