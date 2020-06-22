//
//  MailRepositoryProtocol.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 21/06/2020.
//

import Foundation

protocol  MailRepositoryProtocol {
	func sendMailNotification(subject: String, text: String, html: String) throws 
}

