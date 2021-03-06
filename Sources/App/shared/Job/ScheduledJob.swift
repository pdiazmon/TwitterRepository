//
//  ScheduledJob.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 18/06/2020.
//

import Foundation
import Vapor

class ScheduledJob {
	
	private var container: Container
	private var every: TimeAmount
	private var job: JobProtocol
	private var task: RepeatedTask?
	private var logger: Logger?
	
	var i: Int = 0
	
	init(container: Container, every: TimeAmount, job: JobProtocol) {
		self.container = container
		self.every     = every
		self.job       = job
		
		logger = try? container.make(CustomLogger.self)
	}

	func start() {
		
		self.task = self.container.eventLoop.scheduleRepeatedTask(initialDelay: TimeAmount.seconds(15), delay: self.every)
		{ (task) -> Void in
			self.logger?.info("{\(self.job.getName())} Start running.")
			try self.job.run(container: self.container)
			self.logger?.info("{\(self.job.getName())} finished.")
		}
	}
	
	func stop() {
		self.task?.cancel()
	}
}
