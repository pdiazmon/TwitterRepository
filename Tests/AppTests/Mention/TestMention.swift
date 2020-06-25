@testable import App
import Dispatch
import XCTest
import Vapor


final class TestMention : XCTestCase {
	
	var app: Application?
	
	override func setUp() {
		super.setUp()
	  
		app = try! Application.makeTest(
		configure: { (config, services) in
			
			services.register(MentionCriteriaRepositoryMock.self)
			
			services.register(MentionTweetsRepositoryMock.self)
			
			services.register(MentionRepositoryMock.self)
			
			services.register(AppConfigMock.self)

			services.register(CustomLogger.self) { container -> CustomLogger in
				return try CustomLogger(console: container.make())
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
	
	func testMentionCriteriaEndPointAllOk() throws {
		
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

	func testMentionCriteriaEndPointAddBadCriteria() throws {

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

	func testMentionCriteriaEndPointAddNoCriteria() throws {

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

	func testMentionCriteriaEndPointAddEmptyCriteria() throws {
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

	func testMentionCriteriaAllAction() throws {
		
		let NUMBER_OF_CRITERIAS = 5
		
		XCTAssertNotNil(self.app)

		let action = MentionCriteriaAction()
		let logger = try app?.make(Logger.self)
		let repository = try self.app?.make(MentionCriteriaRepositoryProtocol.self)
		
		XCTAssertNotNil(repository)
		XCTAssertNotNil(logger)

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
	
	func testMentionAllAction() throws {
		let NUMBER_OF_MENTIONS = 5

		XCTAssertNotNil(self.app)

		let action = MentionAction()
		let repository = try self.app?.make(MentionRepositoryProtocol.self)
		
		XCTAssertNotNil(repository)
		
		var newMention: Mention
		
		for i in 1...NUMBER_OF_MENTIONS {
			newMention = Mention(id: i, tweet_id: "\(i)", created_at: Date().description, text: "Mention \(i)", created: Date())
			let _ = try action.addNewMention(newMention, on: repository!).wait()
		}
		
		var allMentions = try action.getAllStoredMentions(on: repository!).wait()
		
		allMentions = allMentions.sorted { ($0.id ?? 0) < ($1.id ?? 0) }
		XCTAssertEqual(allMentions.count, NUMBER_OF_MENTIONS)
		
		for i in 1...NUMBER_OF_MENTIONS {
			XCTAssertEqual(allMentions[i-1].id, i)
		}
	}
	
	func testPurgeMentionsAction() throws {
		
		XCTAssertNotNil(self.app)

		let NUMBER_OF_MENTIONS = 5
		let action = MentionAction()
		let repository = try self.app?.make(MentionRepositoryProtocol.self)
		var newMention: Mention
		let dateFormatter = DateFormatter()
		let purgeJob = try PurgeMentionJob(self.app!)

		XCTAssertNotNil(repository)

		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
		
		for i in 1...NUMBER_OF_MENTIONS {
			let created_at = Calendar.current.date(byAdding: .day, value: -(i-1), to: Date())
			
			XCTAssertNotNil(created_at)
			
			newMention = Mention(id: i,
								 tweet_id: "\(i)",
								 created_at: dateFormatter.string(from: created_at!),
								 text: "Mention \(i)")
			let _ = try action.addNewMention(newMention, on: repository!).wait()
		}

		
		try action.getAllStoredMentions(on: repository!).map { mentions in
		
			try purgeJob.run(container: self.app!)
		
			try action.getAllStoredMentions(on: repository!).do { remainingMentions in
		
				XCTAssertEqual(remainingMentions.count, AppConfigMock.PURGE_BEFORE_DAYS + 1)
			}
		}
		
	}

    static let allTests = [
        ("testMentionCriteriaEndPointAllOk", testMentionCriteriaEndPointAllOk),
		("testMentionCriteriaEndPointAddBadCriteria", testMentionCriteriaEndPointAddBadCriteria),
		("testMentionCriteriaEndPointAddNoCriteria", testMentionCriteriaEndPointAddNoCriteria),
		("testMentionCriteriaEndPointAddEmptyCriteria", testMentionCriteriaEndPointAddEmptyCriteria),
		("testMentionCriteriaAllAction", testMentionCriteriaAllAction),
		("testMentionAllAction", testMentionAllAction),
		("testPurgeMentionsAction", testPurgeMentionsAction)
    ]
}
