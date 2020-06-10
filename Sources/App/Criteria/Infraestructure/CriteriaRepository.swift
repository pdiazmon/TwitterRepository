//
//  CriteriaRepository.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 09/06/2020.
//

import Foundation
import Vapor

class CriteriaRepository: CriteriaRepositoryProtocol {
	let req: Request
	
	init(_ req: Request) {
		self.req = req
	}
	
	func save(_ criteria: Criteria) -> Future<Criteria> {
		
		return criteria.save(on: self.req)
	}
	
	func all() -> Future<[Criteria]> {
		
		return Criteria.query(on: req).all()
	}
	
	
}
