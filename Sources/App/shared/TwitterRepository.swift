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
	
	var req: Request

	enum TwitterEndPoint: String, URLRepresentable {
		func convertToURL() -> URL? {
			return URL(string: self.rawValue)
		}
		
		case followers = "https://api.twitter.com/1.1/followers/list.json"
	}
	
	init(_ req: Request) {
		self.req = req
	}
	
	private lazy var bearer_token: String = {
		let directory = DirectoryConfig.detect()

		do {
			let data = try Data(contentsOf: URL(fileURLWithPath: directory.workDir)
				           .appendingPathComponent("twitter.json", isDirectory: false))

			let dic = try JSONDecoder().decode(TwitterSecrets.self, from: data)

			return dic.bearer_token
			
		} catch {
			print(error)
			return ""
		}
	}()
	
	func newRequest(_ req: Request, endpoint: TwitterEndPoint, queries: TwitterQueries) throws -> EventLoopFuture<Response> {

		return try req.client().get(endpoint.rawValue) { get in

			try get.query.encode(queries)

			// Set the header authorization item
			get.http.headers.add(name: "Authorization",
								 value: "Bearer \(self.bearer_token)")
		}
	}
	
}

