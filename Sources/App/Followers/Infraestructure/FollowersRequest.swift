//
//  FollowersRequest.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 06/06/2020.
//

import Foundation
import Vapor

struct FollowersRequest: Content {
	var screen_name: String
}
