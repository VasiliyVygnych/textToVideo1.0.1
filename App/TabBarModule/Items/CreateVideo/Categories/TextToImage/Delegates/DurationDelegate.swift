//
//  DurationDelegate.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 06.12.2024.
//

import Foundation

enum DurationGenerate {
    case seconds5
    case seconds10
    case none
    case key
    
    var credits: Int {
        switch self {
        case .seconds5:
            return 5
        case .seconds10:
            return 10
        case .none:
            return 0
        case .key:
            return 0
        }
    }
    var value: String {
        switch self {
        case .seconds5:
            return "5 \(HomeConstants.HomeText.secondsTitle.localized(LanguageConstant.appLaunguage))"
        case .seconds10:
            return "10 \(HomeConstants.HomeText.secondsTitle.localized(LanguageConstant.appLaunguage))"
        case .none:
            return ""
        case .key:
            return "writeOffOfLoans"
        }
    }
}

protocol DurationDelegate: AnyObject {
    func setValue(value: String,
                  duration: DurationGenerate)
    func isShowView(_ bool: Bool)
}
