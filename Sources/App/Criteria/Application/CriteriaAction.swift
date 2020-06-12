//
//  CriteriaAction.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 09/06/2020.
//

import Foundation
import Vapor

class CriteriaAction {
	
	func addNewCriteriaAction(_ criteriaToAdd: Criteria, logger: Logger, on repository: CriteriaRepositoryProtocol) -> Future<Criteria> {
		
		return repository.save(criteriaToAdd)
	}

	func getAllCriteriaAction(from repository: CriteriaRepositoryProtocol) -> Future<[Criteria]> {
		return repository.all()
	}
}
