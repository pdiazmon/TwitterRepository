//
//  configure_mention.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 22/06/2020.
//

import Foundation
import Vapor
import Fluent

func configure_mention(services: inout Services) {
	
    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: MentionCriteria.self, database: .sqlite)
	migrations.add(model: Mention.self, database: .sqlite)
    services.register(migrations)
	
	var middlewares = MiddlewareConfig()
	middlewares.use(ExampleMiddleware.self)
	services.register(middlewares)
	services.register(ExampleMiddleware.self)

	services.register(MentionCriteriaRepository.self)
	services.register(MentionTweetsRepository.self)
	services.register(MentionRepository.self)

}
