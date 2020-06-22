//
//  TwitterSecrets.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 07/06/2020.
//

import Foundation

struct TwitterConfig: Codable {
	var twitter_config: TwitterSecrets
}

struct TwitterSecrets: Codable {
	var bearer_token: String
}

