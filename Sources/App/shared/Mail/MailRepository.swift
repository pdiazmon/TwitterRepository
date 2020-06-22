//
//  MailRepository.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 21/06/2020.
//

import Foundation
import Vapor
import Mailgun

class MailRepository: MailRepositoryProtocol {
	
	private var container: Container
	
	required init(_ container: Container) {
		self.container = container
	}
	
	private lazy var config: MailgunConfig? = {
		
		var config = try? self.container.make(AppConfigProtocol.self)
		
		return config?.readConfig(MailgunConfig.self)
		
//		let directory = DirectoryConfig.detect()
//
//		do {
//			let data = try Data(contentsOf: URL(fileURLWithPath: directory.workDir)
//				           .appendingPathComponent("twitterrepository.json", isDirectory: false))
//
//			let dic = try JSONDecoder().decode(MailgunConfig.self, from: data)
//
//			return dic
//
//		} catch {
//			print(error)
//			return nil
//		}
	}()
	
	private lazy var apiKey: String? = {
		return self.config?.mail_config.Mailgun_apiKey
	}()
	
	private lazy var to: String? = {
		return self.config?.mail_config.to
	}()
	
	private lazy var from: String? = {
		return self.config?.mail_config.from
	}()
	
	public func sendMailNotification(subject: String, text: String, html: String) throws {
		
		guard let from = self.from, let to = self.to else { return }
		
		let message = Mailgun.Message(
			from: from,
			to: to,
			subject: subject,
			text: text,
			html: html
		)

		if let apiKey = self.apiKey {
			let mailgun = Mailgun(apiKey: apiKey)
			let _ = try mailgun.send(message, domain: .usDomain, on: self.container)
		}
	}
}

extension MailRepository: ServiceType {
	static func makeService(for container: Container) throws -> Self {
		return .init(container)
	}
}

