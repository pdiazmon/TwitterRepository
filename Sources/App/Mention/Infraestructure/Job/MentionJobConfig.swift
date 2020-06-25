//
//  MentionJobConfig.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 22/06/2020.
//

import Foundation

struct MentionJobConfig: Codable {
	var mention_config: JobConfig
}

struct JobConfig: Codable {
	var job_runs_every_seconds: Int
	var purge_before_days: Int
}
