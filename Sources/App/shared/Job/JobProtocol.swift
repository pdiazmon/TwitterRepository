//
//  JobProtocol.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 18/06/2020.
//

import Foundation
import Vapor

protocol JobProtocol {
	
	func run(container: Container) throws
}
