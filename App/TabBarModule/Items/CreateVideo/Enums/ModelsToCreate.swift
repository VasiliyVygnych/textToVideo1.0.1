//
//  CreateModels.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 12.12.2024.
//

import Foundation

enum ModelsToCreate {
    case dinsonPro
    case dinsonStandart
    case natash
    case none
    
    var value: String {
        switch self {
        case .dinsonPro:
            return "Dinson Pro".localized(LanguageConstant.appLaunguage)
        case .dinsonStandart:
            return "Dinson Standart".localized(LanguageConstant.appLaunguage)
        case .natash:
            return "Natash".localized(LanguageConstant.appLaunguage)
        case .none:
            return ""
        }
    }
}
