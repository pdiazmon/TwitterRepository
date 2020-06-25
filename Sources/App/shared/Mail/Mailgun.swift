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
		return Mailgun.DomainConfig(AppConfig().readConfig(MailgunConfig.self)?.mail_config.Mailgun_eu_domain ?? "", region: .eu)
    }
    static var usDomain: Mailgun.DomainConfig {
        return Mailgun.DomainConfig(AppConfig().readConfig(MailgunConfig.self)?.mail_config.Mailgun_eu_domain ?? "", region: .us)
    }
}
