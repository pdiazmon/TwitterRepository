//
//  TwitterRepository.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 07/06/2020.
//

import Foundation
import Vapor

class TwitterRepository {

	typealias TwitterQueries = [String: String]
	
	var container: Container

	enum TwitterEndPoint: String, URLRepresentable {
		func convertToURL() -> URL? {
			return URL(string: self.rawValue)
		}
		
		case followers = "https://api.twitter.com/1.1/followers/list.json"
		case search = "https://api.twitter.com/1.1/search/tweets.json"
	}
	
	init(_ container: Container) {
		self.container = container
	}
	
	private lazy var bearer_token: String = {
		
		guard let config = try? self.container.make(AppConfigProtocol.self) else { return "" }
		
		return config.readConfig(TwitterConfig.self)?.twitter_config.bearer_token ?? ""
		
//		let directory = DirectoryConfig.detect()
//
//		do {
//			let data = try Data(contentsOf: URL(fileURLWithPath: directory.workDir)
//				           .appendingPathComponent("twitterrepository.json", isDirectory: false))
//
//			let dic = try JSONDecoder().decode(TwitterConfig.self, from: data)
//
//			return dic.twitter_config.bearer_token
//
//		} catch {
//			print(error)
//			return ""
//		}
	}()
	
	func newRequest(_ container: Container, endpoint: TwitterEndPoint, queries: TwitterQueries) throws -> EventLoopFuture<Response> {

		return try container.client().get(endpoint.rawValue) { get in

			try get.query.encode(queries)

			// Set the header authorization item
			get.http.headers.add(name: "Authorization",
								 value: "Bearer \(self.bearer_token)")
		}
	}
	
}

