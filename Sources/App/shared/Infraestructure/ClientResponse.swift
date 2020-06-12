//
//  ClientResponse.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 12/06/2020.
//

import Foundation
import Vapor

struct ResponseError: Content {
	var description: String
	var code: Int
}

struct ClientResponse: Content {
	var error: ResponseError? 
}
