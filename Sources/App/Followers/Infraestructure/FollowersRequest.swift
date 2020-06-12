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

extension FollowersRequest: Validatable {
	
	static func validations() throws -> Validations<FollowersRequest> {

		var validations = Validations(FollowersRequest.self)
		
		validations.add(\.screen_name, at: ["screen_name"], .count(1...))

        return validations
    }
}
