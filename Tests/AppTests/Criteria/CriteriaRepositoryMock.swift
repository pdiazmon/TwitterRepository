//
//  CriteriaRepositoryMock.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 10/06/2020.
//

import Foundation
import Vapor
@testable import App

public class CriteriaRepositoryMock: CriteriaRepositoryProtocol {
	public var req: Request?
	var criterias: [Criteria] = []
	
	public func save(_ criteria: Criteria) -> EventLoopFuture<Criteria> {
		
		let promise = req?.eventLoop.newPromise(of: Criteria.self)
		
		self.criterias.append(criteria)
		
		promise!.succeed(result: criteria)
		
		return promise!.futureResult
	}
	
	public func all() -> EventLoopFuture<[Criteria]> {
		
		let promise = req?.eventLoop.newPromise(of: [Criteria].self)
				
		promise!.succeed(result: self.criterias)
		
		return promise!.futureResult
	}
}
