import Vapor
import FluentSQLite
import Fluent

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
//	let directoryConfig = DirectoryConfig.detect()
//	services.register(directoryConfig)
	
//	try services.register(FluentSQLiteProvider())
//	var databasesConfig = DatabasesConfig()
//	let db = try SQLiteDatabase(storage: .memory)
//	databasesConfig.add(database: db, as: .sqlite)
//	services.register(databasesConfig)
//
//	var migrationConfig = MigrationConfig()
//	migrationConfig.add(model: Criteria.self, database: .sqlite)
//	services.register(migrationConfig)
	
	try services.register(FluentSQLiteProvider())
	
    // Configure a SQLite database
    let sqlite = try SQLiteDatabase(storage: .memory)

    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Criteria.self, database: .sqlite)
    services.register(migrations)

//	var middlewares = MiddlewareConfig()
//	middlewares.use(MyMiddleware.self)
//	services.register(middlewares)
	
}
