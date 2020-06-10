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
		
		return repository.save(criteriaToAdd).map{ savedCriteria in
			
			logger.debug("New Criteria created \(savedCriteria)")
			
			let _ = self.getAllCriteriaAction(from: repository).do { existingCriterias in
				logger.info("There are now \(String(existingCriterias.count)) criterias in the repository")
			}
			
			return savedCriteria
		}
	}

	func getAllCriteriaAction(from repository: CriteriaRepositoryProtocol) -> Future<[Criteria]> {
		return repository.all()
	}
}
