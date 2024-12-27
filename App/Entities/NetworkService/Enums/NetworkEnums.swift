//
//  NetworkEnums.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 28.11.2024.
//

import Foundation

enum GenerationType {
    case youtube
    case instagram
    case any
    
    var valueType: String {
        switch self {
        case .youtube:
            return "youtube"
        case .instagram:
            return "instagram"
        case .any:
            return ""
        }
    }
}

enum RequestType {
    case textToVideo
    case imageToVideo
    case any
    
    var value: String {
        switch self {
        case .textToVideo:
            return "text-to-video"
        case .imageToVideo:
            return "image-to-video"
        case .any:
            return ""
        }
    }
}
