//
//  CriteriaRepository.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 09/06/2020.
//

import Foundation
import Vapor

class CriteriaRepository: CriteriaRepositoryProtocol {

	var req: Request?
	
	func save(_ criteria: Criteria) -> Future<Criteria> {
		
		return criteria.save(on: req!)
	}
	
	func all() -> Future<[Criteria]> {
		
		return Criteria.query(on: req!).all()
	}
	
	
}
