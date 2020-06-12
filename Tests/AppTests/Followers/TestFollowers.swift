//
//  TestFollowers.swift
//  AppTests
//
//  Created by Pedro L. Diaz Montilla on 11/06/2020.
//

@testable import App
import Dispatch
import XCTest
import Vapor


final class TestFollowers : XCTestCase {
	
	var app: Application?
	
	override func setUp() {
	  super.setUp()
	  
	  app = try! Application.makeTest(routes: testRoutes)

//		var middlewares = MiddlewareConfig()
//		middlewares.use(MyMiddleware.self)
//		app?.services.register(middlewares)

	}
	
	override func tearDown() {
	  super.tearDown()
	  
	  app = nil
	}
	
	private func testRoutes(_ router: Router) throws {
		let followerController = FollowersController(repository: FollowersRepositoryMock())
		
		try router.register(collection: followerController)
	}
	
	func testFollowersEndPointOk() throws {
		
		let expectation = self.expectation(description: "Followers")
		var followers: [Follower] = []
		
		var newRequest = HTTPRequest()
		newRequest.method      = .GET
		newRequest.url         = URL(string: "/followers")!
		newRequest.body        = HTTPBody(data: try JSONEncoder().encode(FollowersRequest(screen_name: "TEST")))
		newRequest.contentType = MediaType.json
		
		try app?.test(newRequest) { (response) in

			followers = try JSONDecoder().decode([Follower].self, from: response.http.body.data!)

			XCTAssertEqual(response.http.status, .ok)
			XCTAssertEqual(response.http.contentType, MediaType.json)
			XCTAssertEqual(followers.count, FollowersRepositoryMock.followers.count)
			
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		
	}

	func testFollowersEndPointNoUser() throws {
		
		let expectation = self.expectation(description: "Followers")
		
		var newRequest = HTTPRequest()
		newRequest.method      = .GET
		newRequest.url         = URL(string: "/followers")!
		newRequest.contentType = MediaType.json
		
		try app?.test(newRequest) { (response) in
			
			XCTAssertEqual(response.http.status, .badRequest)

			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		
	}
	
	func testFollowersEndPointEmptyUser() throws {
		
		let expectation = self.expectation(description: "Followers")
		
		var newRequest = HTTPRequest()
		newRequest.method      = .GET
		newRequest.url         = URL(string: "/followers")!
		newRequest.body        = HTTPBody(data: try JSONEncoder().encode(FollowersRequest(screen_name: "")))
		newRequest.contentType = MediaType.json
		
		try app?.test(newRequest) { (response) in
			
			XCTAssertEqual(response.http.status, .badRequest)

			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		
	}

	func testFollowersActions() throws {
		let action = FollowersAction()
		let repository = FollowersRepositoryMock()
		repository.req = Request(using: app!)
		
		let followers = try action.getFollowers(by: "TEST", using: repository).wait()
		
		XCTAssertEqual(followers.count, FollowersRepositoryMock.followers.count)
	}

    static let allTests = [
        ("testFollowersEndPoint", testFollowersEndPointOk),
		("testFollowersEndPointNoUser", testFollowersEndPointNoUser),
		("testFollowersActions", testFollowersActions),
		("testFollowersEndPointEmptyUser", testFollowersEndPointEmptyUser),
    ]
}

