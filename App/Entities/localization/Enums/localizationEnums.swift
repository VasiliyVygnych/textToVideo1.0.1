//
//  localizationEnums.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 09.11.2024.
//

import Foundation

enum LanguageConstant {
    static let localizeKey = "localizeVideoApp"
    static var appLaunguage = AppLanguage.english.id
}

enum AppLanguage: Int {
    case english
    case russian
    case german
    case spanish
    case french
    case italian
    
    var id: String {
        switch self {
        case .english:
            return "en"
        case .russian:
            return "ru"
        case .german:
            return "de"
        case .spanish:
            return "es"
        case .french:
            return "fr"
        case .italian:
            return "it"
        }
    }
}
