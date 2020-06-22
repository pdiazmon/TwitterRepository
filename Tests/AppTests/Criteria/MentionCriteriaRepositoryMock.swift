//
//  MentionCriteriaRepositoryMock.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 10/06/2020.
//

import Foundation
import Vapor
@testable import App

public class MentionCriteriaRepositoryMock: MentionCriteriaRepositoryProtocol {
	
	public var container: Container
	
	var criterias: [MentionCriteria] = []
	
	init(_ container: Container) {
		self.container = container
	}
	
	public func save(_ criteria: MentionCriteria) -> EventLoopFuture<MentionCriteria> {
		
		let promise = container.eventLoop.newPromise(of: MentionCriteria.self)
		
		self.criterias.append(criteria)
		
		promise.succeed(result: criteria)
		
		return promise.futureResult
	}
	
	public func all() -> EventLoopFuture<[MentionCriteria]> {
		
		let promise = container.eventLoop.newPromise(of: [MentionCriteria].self)
				
		promise.succeed(result: self.criterias)
		
		return promise.futureResult
	}
}

extension MentionCriteriaRepositoryMock: Service {}
