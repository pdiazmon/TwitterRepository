//
//  CriteriaSaver.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 09/06/2020.
//

import Foundation
import Vapor

protocol CriteriaRepositoryProtocol {

	var req: Request? { get set }

	func save(_ criteria: Criteria) -> Future<Criteria>
	
	func all() -> Future<[Criteria]>
}
