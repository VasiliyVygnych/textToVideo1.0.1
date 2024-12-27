//
//  VideoToVideoData.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 09.12.2024.
//

import UIKit

struct VideoToVideoData {
    let urlString: String?
    let styleMode: String?
    let setyleImage: UIImage?
}

struct CategoryData {
    let image: UIImage?
    let name: String
}

let categoriesModel: [CategoryData] = [
    .init(image: UIImage(named: "category1"),
          name: "Android".localized(LanguageConstant.appLaunguage)),
    .init(image: UIImage(named: "category2"),
          name: "Ballon Face".localized(LanguageConstant.appLaunguage)),
    .init(image: UIImage(named: "category3"),
          name: "Claymation".localized(LanguageConstant.appLaunguage)),
    .init(image: UIImage(named: "category4"),
          name: "Cloudscape".localized(LanguageConstant.appLaunguage)),
    .init(image: UIImage(named: "category5"),
          name: "Green".localized(LanguageConstant.appLaunguage)),
    .init(image: UIImage(named: "category6"),
          name: "Iso".localized(LanguageConstant.appLaunguage)),
    .init(image: UIImage(named: "category7"),
          name: "Category".localized(LanguageConstant.appLaunguage)),
    .init(image: UIImage(named: "category8"),
          name: "Category".localized(LanguageConstant.appLaunguage)),
    .init(image: UIImage(named: "category9"),
          name: "Category".localized(LanguageConstant.appLaunguage)),
    .init(image: UIImage(named: "category10"),
          name: "Category".localized(LanguageConstant.appLaunguage))
    ]
