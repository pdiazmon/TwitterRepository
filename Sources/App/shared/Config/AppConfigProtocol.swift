//
//  AppConfigProtocol.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 22/06/2020.
//

import Foundation

protocol AppConfigProtocol {
	func readConfig<T: Codable>(_ type: T.Type) -> T?
}
