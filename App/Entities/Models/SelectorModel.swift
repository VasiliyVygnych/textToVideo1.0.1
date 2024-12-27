//
//  SelectorModel.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 05.12.2024.
//

import UIKit

struct SelectorModel {
    let previewImage: UIImage?
    let title: String
    let selector: SelectorEnums
}

let selectorModel: [SelectorModel] = [
    .init(previewImage: UIImage(named: "selectFirst"),
          title: "Text/Image to video".localized(LanguageConstant.appLaunguage),
          selector: .textImageToVideo),
    .init(previewImage: UIImage(named: "selectSecond"),
          title: "Video to video".localized(LanguageConstant.appLaunguage),
          selector: .videoToVideo),
    .init(previewImage: UIImage(named: "selectThird"),
          title: "Advanced video".localized(LanguageConstant.appLaunguage),
          selector: .base)
    ]
