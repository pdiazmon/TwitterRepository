//
//  MentionRepositoryMock.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 21/06/2020.
//

import Foundation
import Vapor
@testable import App

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
	
	func purgeOlder(than days: Int) throws -> EventLoopFuture<Int> {
		let promise = container.eventLoop.newPromise(of: Int.self)
		
		let current = self.mentions.count
		
		guard let compareDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) else { return promise.futureResult }
		
		self.mentions = self.mentions.filter {
			guard let created_at = $0.created_at.toTwitterDate() else { return false }
			return created_at < compareDate
		}
		
		promise.succeed(result: current - self.mentions.count)
		
		return promise.futureResult
	}
	
}

extension MentionRepositoryMock: ServiceType {
    /// See `ServiceType`.
	public static var serviceSupports: [Any.Type] {
        return [MentionRepositoryProtocol.self]
    }

    /// See `ServiceType`.
	public static func makeService(for worker: Container) throws -> Self {
		return MentionRepositoryMock(worker) as! Self
    }
}
