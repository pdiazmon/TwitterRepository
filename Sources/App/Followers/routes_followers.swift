//
//  routes_followers.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 22/06/2020.
//

import Foundation
import Vapor

public func routes_followers(_ router: Router) throws {
	
	let followersController = FollowersController()
	
	try router.register(collection: followersController)
	
}
