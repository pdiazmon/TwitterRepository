//
//  CriteriaController.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 09/06/2020.
//

import Foundation
import Vapor

class CriteriaController: RouteCollection {
	
	var repository: CriteriaRepositoryProtocol
	
	init(repository: CriteriaRepositoryProtocol) {
		self.repository = repository
	}
	
	func boot(router: Router) throws {
		
		router.group("criteria") { (group) in
			group.post(Criteria.self, at: "add", use: self.addNewCriteria)
			group.get("all", use: self.getAllCriteria)
		}
	}
}

extension CriteriaController {
	
	func addNewCriteria(_ req: Request, container: Criteria) throws -> Future<Criteria> {

		let action = CriteriaAction()
		let logger = try req.make(Logger.self)
		
		repository.req = req

		try container.validate()

		return action.addNewCriteriaAction(container, logger: logger, on: repository)
	}
	
	func getAllCriteria(_ req: Request) throws -> Future<[Criteria]> {
		
		let action = CriteriaAction()

		repository.req = req
		
		return action.getAllCriteriaAction(from: repository)
	}
	
}
