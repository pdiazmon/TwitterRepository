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
}

extension AppConfig: ServiceType {
    /// See `ServiceType`.
	public static var serviceSupports: [Any.Type] {
        return [AppConfigProtocol.self]
    }

    /// See `ServiceType`.
	public static func makeService(for worker: Container) throws -> Self {
		return AppConfig() as! Self
    }
}
