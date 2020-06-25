//
//  String.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 25/06/2020.
//

import Foundation

extension String {
	
	func toTwitterDate() -> Date? {
		
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"

		return dateFormatter.date(from: self)
	}
}
