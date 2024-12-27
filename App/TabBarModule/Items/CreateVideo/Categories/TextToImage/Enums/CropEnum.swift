//
//  CropEnum.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 06.12.2024.
//

import Foundation

enum CropEnum {
    case horizontal
    case vertical
    
    var value: String {
        switch self {
        case .horizontal:
            return "horizontal"
        case .vertical:
            return "vertical:"
        }
    }
}
