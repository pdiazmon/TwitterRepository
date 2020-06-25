//
//  configure_followers.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 22/06/2020.
//

import Foundation
import Vapor

func configure_followers(services: inout Services) {
	
	services.register(FollowersRepository.self)

}
