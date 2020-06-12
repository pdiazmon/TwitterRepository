//
//  MyMiddleware.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 12/06/2020.
//

import Foundation
import Vapor

class MyMiddleware: Middleware {
	func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
		print("Middleware: Executing respond !!!!!")
		
		return request.eventLoop.newPromise(of: Response.self).futureResult

	}
	
	func makeResponder(chainingTo responder: Responder) -> Responder {
		return responder
	}
	
}
