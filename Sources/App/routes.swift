import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
	
	let criteriaController  = CriteriaController(repository: CriteriaRepository())
	let followersController = FollowersController(repository: FollowersRepository())
	
	try router.register(collection: criteriaController)
	try router.register(collection: followersController)
}


