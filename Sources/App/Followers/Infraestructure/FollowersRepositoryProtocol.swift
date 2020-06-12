//
//  FollowersRepositoryProtocol.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 09/06/2020.
//

import Foundation
import Vapor

protocol FollowersRepositoryProtocol {
	
	var req: Request? { get set }
	
	func getFollowers(of screen_name: String) throws -> Future<[Follower]>
}
