//
//  routes_mention.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 22/06/2020.
//

import Foundation
import Vapor

public func routes_mention(_ router: Router) throws {
	
	let mentionController  = MentionController()
	
	try router.register(collection: mentionController)
	
}
