//
//  InfoCreditModel.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 26.12.2024.
//

import Foundation

struct InfoCreditData {
    let title: String
    let subtitle: String
}
let credit = "credits".localized(LanguageConstant.appLaunguage)
let infoCreditData: [InfoCreditData] = [
                    .init(title: "10 \(credit)".localized(LanguageConstant.appLaunguage),
                          subtitle: "1 minimax generation".localized(LanguageConstant.appLaunguage)),
                    .init(title: "10 \(credit)".localized(LanguageConstant.appLaunguage),
                          subtitle: "1 kling generation (10sec)".localized(LanguageConstant.appLaunguage)),
                    .init(title: "5 \(credit)",
                          subtitle: "1 kling generation (5sec)".localized(LanguageConstant.appLaunguage))
                    ]
