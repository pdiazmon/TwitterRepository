//
//  MyLogger.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 18/06/2020.
//

import Foundation
import Vapor
import Logging

public class CustomLogger: Logger {
	
    /// The `Console` logs will be outputted to.
    public let console: Console

    /// Create a new `ConsoleLogger`.
    public required init(console: Console) {
        self.console = console
    }

    public func log(_ string: String, at level: LogLevel, file: String, function: String, line: UInt, column: UInt) {
        
		let text: ConsoleText = ""
			+ "[\(level)] ".consoleText()
            + string.consoleText()
        console.output(text)
    }
}

extension CustomLogger: Service {}

