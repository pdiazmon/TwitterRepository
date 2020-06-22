//
//  Mailgun.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 21/06/2020.
//

import Foundation
import Mailgun

extension Mailgun.DomainConfig {
    static var euDomain: Mailgun.DomainConfig {
        return Mailgun.DomainConfig(AppConfig.getMailgunDomain(.eu) ?? "", region: .eu)
    }
    static var usDomain: Mailgun.DomainConfig {
        return Mailgun.DomainConfig(AppConfig.getMailgunDomain(.us) ?? "", region: .us)
    }
}
