//
//  MailgunConfig.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 21/06/2020.
//

import Foundation

struct MailgunConfig: Codable {
	var mail_config: MailConfig
}

struct MailConfig: Codable {
	var to: String
	var from: String
	var Mailgun_apiKey: String
	var Mailgun_eu_domain: String
	var Mailgun_us_domain: String
}
