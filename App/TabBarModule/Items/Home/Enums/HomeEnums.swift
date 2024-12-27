//
//  HomeEnums.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 17.10.2024.
//

import Foundation

enum PluginMode {
    case none
    case basicWorkflows
    case scriptToVideo
    case youtubeShorts
    case instagramReels
    
    var pluginType: String {
        switch self {
        case .none:
            return ""
        case .basicWorkflows:
            return ""
        case .scriptToVideo:
            return ""
        case .youtubeShorts:
            return "youtube"
        case .instagramReels:
            return "instagram"
        }
    }
    var value: String {
        switch self {
        case .none:
            return ""
        case .basicWorkflows:
            return "BasicWorkflows:"
        case .scriptToVideo:
            return "ScriptToVideo:"
        case .youtubeShorts:
            return "YoutubeShorts:"
        case .instagramReels:
            return "InstagramReels:"
        }
    }
}
