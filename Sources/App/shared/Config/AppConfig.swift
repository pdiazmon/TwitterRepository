//
//  AppConfig.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 22/06/2020.
//

import Foundation
import Vapor
import Mailgun

class AppConfig: AppConfigProtocol {
	
	func readConfig<T: Codable>(_ type: T.Type = T.self) -> T? {
		
		let directory = DirectoryConfig.detect()

		do {
			let data = try Data(contentsOf: URL(fileURLWithPath: directory.workDir)
						   .appendingPathComponent("twitterrepository.json", isDirectory: false))

			let dic = try JSONDecoder().decode(type, from: data)
			
			return dic
			
		} catch {
			print(error)
			return nil
		}
	}
	
	static func getMailgunDomain(_ region: Mailgun.Region) -> String? {
		let appConfig = AppConfig()
		let mail_config = appConfig.readConfig(MailgunConfig.self)?.mail_config
		
		switch region {
			case .eu:
				return mail_config?.Mailgun_eu_domain
			case .us:
				return mail_config?.Mailgun_us_domain
		}
	}
}

extension AppConfig: Service {}
