//
//  Enums.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 14.10.2024.
//

import Foundation

enum Regex: String {
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    case phone = "(\\s*)?(\\+)?([- _():=+]?\\d[- _():=+]?){11,14}(\\s*)?"
}

enum ModeShowSubscription {
    case monthly
    case yearly
    case none
}

enum SelectSubscription {
    case plus
    case ultra
    case free
}

enum SettingsWebView {
    case none
    case termsOfUse
    case privacyPolicy
}
