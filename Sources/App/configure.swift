import Vapor
import FluentSQLite
import Fluent
import Mailgun

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Configure DB
	try services.register(FluentSQLiteProvider())
	
    // Configure a SQLite database
    let sqlite = try SQLiteDatabase(storage: .memory)

    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)

	// ******************************
	// Shared services
	// ******************************
	services.register(MailRepositoryProtocol.self) { container in
		return MailRepository(container)
	}

	services.register(CustomLogger.self) { container -> CustomLogger in
		return try CustomLogger(console: container.make())
	}
	
	services.register(AppConfigProtocol.self) { _ in
		return AppConfig()
	}

	// ******************************
	// Followers module
	// ******************************
	
	configure_followers(services: &services)
	
	// ******************************
	// Mention module
	// ******************************
	
	configure_mention(services: &services)
	
}


