//
//  CriteriaController.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 09/06/2020.
//

import Foundation
import Vapor

class CriteriaController: RouteCollection {
	
	func boot(router: Router) throws {
		
		router.group("criteria") { (group) in
			group.post(Criteria.self, at: "add", use: self.addNewCriteria)
			group.get("all", use: self.getAllCriteria)
		}
	}
}

extension CriteriaController {
	
	func addNewCriteria(_ req: Request, container: Criteria) throws -> Future<Criteria> {

		let action             = CriteriaAction()
		let criteriaRepository = CriteriaRepository(req)
		let logger             = try req.make(Logger.self)

		return action.addNewCriteriaAction(container,
												logger: logger,
												on: criteriaRepository)
	}
	
	func getAllCriteria(_ req: Request) throws -> Future<[Criteria]> {
		
		let action             = CriteriaAction()
		let criteriaRepository = CriteriaRepository(req)
		
		return action.getAllCriteriaAction(from: criteriaRepository)
	}
	
}
