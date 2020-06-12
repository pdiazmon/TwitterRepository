@testable import App
import Dispatch
import XCTest
import Vapor


final class TestCriteria : XCTestCase {
	
	var app: Application?
	
	override func setUp() {
	  super.setUp()
	  
	  app = try! Application.makeTest(routes: testRoutes)
	}
	
	override func tearDown() {
	  super.tearDown()
	  
	  app = nil
	}
	
	private func testRoutes(_ router: Router) throws {
		let criteriaController = CriteriaController(repository: CriteriaRepositoryMock())
		
		try router.register(collection: criteriaController)
	}
	
	private func createNewCriteria(id: Int, criteria: String) throws {

		let newExpectation = self.expectation(description: "criteria")
		let newCriteria = Criteria(id: id, criteria: criteria)
		
		var newRequest = HTTPRequest(method: .POST,
									 url: URL(string: "/criteria/add")!,
									 body: HTTPBody(data: try JSONEncoder().encode(newCriteria)))
					
		newRequest.headers.add(name: "Content-Type", value: "application/json")

		try app?.test(newRequest) { (response) in
			let _ = try JSONDecoder().decode(Criteria.self, from: response.http.body.data!)
			
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
		var criterias: [Criteria] = []
		
		try app?.test(.GET, "/criteria/all") { (response) in

			let decoder = JSONDecoder()
			criterias = try decoder.decode([Criteria].self, from: response.http.body.data!)

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
									 url: URL(string: "/criteria/add")!,
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
									 url: URL(string: "/criteria/add")!)
					
		newRequest.headers.add(name: "Content-Type", value: "application/json")

		try app?.test(newRequest) { (response) in
			XCTAssertEqual(response.http.status, .badRequest)

			newExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
	}

	func testCriteriaEndPointsEmptyCriteria() throws {
		let newExpectation = self.expectation(description: "criteria")
		let newCriteria = Criteria(id: 1, criteria: "")
		
		var newRequest = HTTPRequest(method: .POST,
									 url: URL(string: "/criteria/add")!,
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
		
		let action = CriteriaAction()
		let logger = try app?.make(Logger.self)
		let repository = CriteriaRepositoryMock()
		
		repository.req = Request(using: app!)
		
		var newCriteria: Criteria
		
		for i in 1...NUMBER_OF_CRITERIAS {
			newCriteria = Criteria(id: i, criteria: "Criteria \(i)", created: Date())
			let _ = try action.addNewCriteriaAction(newCriteria, logger: logger!, on: repository).wait()
		}
		
		var allCriterias = try action.getAllCriteriaAction(from: repository).wait()
		
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
