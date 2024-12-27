//
//  SelectorEnums.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 05.12.2024.
//

import Foundation

enum SelectorEnums {
    case textImageToVideo
    case videoToVideo
    case base
    case none
    
    var value: String {
        switch self {
        case .textImageToVideo:
            return "first"
        case .videoToVideo:
            return "second"
        case .base:
            return "third"
        case .none:
            return "none"
        }
    }
    var type: String {
        switch self {
        case .textImageToVideo:
            return "textImageToVideo"
        case .videoToVideo:
            return "videoToVideo"
        case .base:
            return "advanced"
        case .none:
            return "none"
        }
    }
}
