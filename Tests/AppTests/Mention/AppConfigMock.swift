//
//  AppConfigMock.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 24/06/2020.
//

@testable import App
import Foundation
import Vapor

class AppConfigMock: AppConfigProtocol {
	
	static let PURGE_BEFORE_DAYS = 2
	
	func readConfig<T: Codable>(_ type: T.Type) -> T? {
		
		switch type {
			case is MentionJobConfig.Type:
				return MentionJobConfig(mention_config: JobConfig(job_runs_every_seconds: 1, purge_before_days: Self.PURGE_BEFORE_DAYS)) as? T 
			default:
				return nil
		}
	}
}


extension AppConfigMock: ServiceType {
    /// See `ServiceType`.
	public static var serviceSupports: [Any.Type] {
        return [AppConfigProtocol.self]
    }

    /// See `ServiceType`.
	public static func makeService(for worker: Container) throws -> Self {
		return AppConfigMock() as! Self
    }
}
