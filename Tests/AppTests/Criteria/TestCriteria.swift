@testable import App
import Dispatch
import XCTest
import Vapor


final class TestCriteria : XCTestCase {
	
	var app: Application?
	
	override func setUp() {
		super.setUp()
	  
		app = try! Application.makeTest(
		configure: { (config, services) in
			
			services.register(MentionCriteriaRepositoryProtocol.self) { container in
				return MentionCriteriaRepositoryMock(container)
			}
			
			services.register(MentionTweetsRepositoryProtocol.self) { container in
				return MentionTweetsRepositoryMock(container)
			}
			
			services.register(MentionRepositoryProtocol.self) { container in
				return MentionRepositoryMock(container)
			}

		},
		routes: { (router) in
			
			let mentionController = MentionController()
			try router.register(collection: mentionController)
		})
	}
	
	override func tearDown() {
	  super.tearDown()
	  
	  app = nil
	}
	
	private func createNewCriteria(id: Int, criteria: String) throws {

		let newExpectation = self.expectation(description: "criteria")
		let newCriteria = MentionCriteria(id: id, user: criteria)
		
		var newRequest = HTTPRequest(method: .POST,
									 url: URL(string: "/mention/criteria/add")!,
									 body: HTTPBody(data: try JSONEncoder().encode(newCriteria)))
					
		newRequest.headers.add(name: "Content-Type", value: "application/json")

		try app?.test(newRequest) { (response) in
			let _ = try JSONDecoder().decode(MentionCriteria.self, from: response.http.body.data!)
			
			newExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
	}
	
	func testCriteriaEndPointsOk() throws {
		
		let NUMBER_OF_CRITERIAS = 5
		
		for i in 1...NUMBER_OF_CRITERIAS {
			try createNewCriteria(id: i, criteria: "criteria \(i)")
		}
		
		let expectation = self.expectation(description: "Criteria")
		var criterias: [MentionCriteria] = []
		
		try app?.test(.GET, "/mention/criteria/all") { (response) in

			let decoder = JSONDecoder()
			criterias = try decoder.decode([MentionCriteria].self, from: response.http.body.data!)

			XCTAssertEqual(response.http.status, .ok)
			XCTAssertEqual(response.http.contentType, MediaType.json)
			XCTAssertEqual(criterias.count, NUMBER_OF_CRITERIAS)
			
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		
		criterias = criterias.sorted { $0.id! < $1.id! }
		
		for i in 1...NUMBER_OF_CRITERIAS {
			XCTAssertEqual(criterias[i-1].id, i)
		}
		
	}

	func testCriteriaEndPointsBadCriteria() throws {

		let newExpectation = self.expectation(description: "criteria")
		let newCriteria4Test = Criteria4Test(id: 1, criteria4Test: "Wrongly named criteria")
		
		var newRequest = HTTPRequest(method: .POST,
									 url: URL(string: "/mention/criteria/add")!,
									 body: HTTPBody(data: try JSONEncoder().encode(newCriteria4Test)))
					
		newRequest.headers.add(name: "Content-Type", value: "application/json")

		try app?.test(newRequest) { (response) in
			XCTAssertEqual(response.http.status, .badRequest)

			newExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
	}

	func testCriteriaEndPointsNoCriteria() throws {

		let newExpectation = self.expectation(description: "criteria")
		
		var newRequest = HTTPRequest(method: .POST,
									 url: URL(string: "/mention/criteria/add")!)
					
		newRequest.headers.add(name: "Content-Type", value: "application/json")

		try app?.test(newRequest) { (response) in
			XCTAssertEqual(response.http.status, .badRequest)

			newExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
	}

	func testCriteriaEndPointsEmptyCriteria() throws {
		let newExpectation = self.expectation(description: "criteria")
		let newCriteria = MentionCriteria(id: 1, user: "")
		
		var newRequest = HTTPRequest(method: .POST,
									 url: URL(string: "/mention/criteria/add")!,
									 body: HTTPBody(data: try JSONEncoder().encode(newCriteria)))
					
		newRequest.headers.add(name: "Content-Type", value: "application/json")

		try app?.test(newRequest) { (response) in
			XCTAssertEqual(response.http.status, .badRequest)

			newExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
	}

	func testCriteriaActions() throws {
		
		let NUMBER_OF_CRITERIAS = 5
		
		let action = MentionCriteriaAction()
		let logger = try app?.make(Logger.self)
		let repository = try self.app?.make(MentionCriteriaRepositoryProtocol.self)
		
		var newCriteria: MentionCriteria
		
		for i in 1...NUMBER_OF_CRITERIAS {
			newCriteria = MentionCriteria(id: i, user: "Criteria \(i)", created: Date())
			let _ = try action.addNewMentionAction(newCriteria, logger: logger!, on: repository!).wait()
		}
		
		var allCriterias = try action.getAllStoredMentionCriteriasAction(from: repository!).wait()
		
		allCriterias = allCriterias.sorted { $0.id! < $1.id! }
		XCTAssertEqual(allCriterias.count, NUMBER_OF_CRITERIAS)
		
		for i in 1...NUMBER_OF_CRITERIAS {
			XCTAssertEqual(allCriterias[i-1].id, i)
		}
	}

    static let allTests = [
        ("testCriteriaEndPointsOk", testCriteriaEndPointsOk),
		("testCriteriaActions", testCriteriaActions),
		("testCriteriaEndPointsEmptyCriteria", testCriteriaEndPointsEmptyCriteria),
		("testCriteriaEndPointsBadCriteria", testCriteriaEndPointsBadCriteria),
		("testCriteriaEndPointsNoCriteria", testCriteriaEndPointsNoCriteria),
    ]
}
