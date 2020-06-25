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

		app = try! Application.makeTest(
		configure: { (config, services) in
			
			var middlewares = MiddlewareConfig.default()
			middlewares.use(ExampleMiddleware.self)
			services.register(middlewares)

			services.register(ExampleMiddleware.self)
			
			services.register(FollowersRepositoryMock.self)

		},
		routes: { (router) in
			
			let followerController = FollowersController()
			try router.register(collection: followerController)
		})
	}
	
	override func tearDown() {
	  super.tearDown()
	  
	  app = nil
	}
		
	func testFollowersEndPointOk() throws {
		
		let expectation = self.expectation(description: "Followers")
		var followers: [Follower] = []
		
		var newRequest = HTTPRequest()
		newRequest.method      = .GET
		newRequest.url         = URL(string: "/followers?screen_name=TEST")!
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
		newRequest.url         = URL(string: "/followers?screen_name=")!
		newRequest.contentType = MediaType.json
		
		try app?.test(newRequest) { (response) in
			
			XCTAssertEqual(response.http.status, .badRequest)

			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		
	}

	func testFollowersActions() throws {
		let action = FollowersAction()
		let repository =  try self.app?.make(FollowersRepositoryProtocol.self)
		
		let followers = try action.getFollowers(by: "TEST", using: repository!).wait()
		
		XCTAssertEqual(followers.count, FollowersRepositoryMock.followers.count)
	}

    static let allTests = [
        ("testFollowersEndPoint", testFollowersEndPointOk),
		("testFollowersEndPointNoUser", testFollowersEndPointNoUser),
		("testFollowersActions", testFollowersActions),
		("testFollowersEndPointEmptyUser", testFollowersEndPointEmptyUser),
    ]
}

