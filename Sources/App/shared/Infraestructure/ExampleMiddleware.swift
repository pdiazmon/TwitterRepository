//
//  ExampleMiddleware.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 13/06/2020.
//

import Foundation
import Vapor


public struct ExampleMiddleware: Middleware {
	
	public func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {
		
		return try next.respond(to: request)
	}
}

extension ExampleMiddleware: ServiceType {

	public static func makeService(for worker: Container) throws -> Self {
	  return .init()
	}
}
