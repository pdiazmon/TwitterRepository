//
//  boot_mention.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 22/06/2020.
//

import Foundation
import Vapor

enum MentionError: Error {
	case ConfigError
}

func boot_mention(_ app: Application) throws {
	
	guard let config = try mention_config(app) else { throw MentionError.ConfigError }
	
	let job = try MentionJob(app)
	
	let scheduledJob = ScheduledJob(container: app,
									every: TimeAmount.seconds(config.mention_config.job_runs_every_seconds),
									job: job)
	scheduledJob.start()

}

fileprivate func mention_config(_ app: Application) throws -> MentionJobConfig? {
	
	var config = try app.make(AppConfigProtocol.self)
	
	return config.readConfig(MentionJobConfig.self)
		
}
