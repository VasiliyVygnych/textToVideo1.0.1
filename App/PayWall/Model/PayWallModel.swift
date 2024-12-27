//
//  PayWallModel.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 23.12.2024.
//

import Foundation

enum PayWallType {
    case free
    case plus
    case ultra
}
struct PayWallData {
    let index: Int
    let name: String
    let description: String
    let type: PayWallType
    let model: [PayWallDescription]
    var price: String?
    var discount: String?
    let duration: SubscriptionDuration
}
struct PayWallDescription {
    let description: String
    let included: Bool
}
var payWallData: [PayWallData] = [
//MARK: Monthly
    .init(index: 0,
          name: "Plus".localized(LanguageConstant.appLaunguage),
          description: "Increased tariff with additional basic credits and expanded functionality".localized(LanguageConstant.appLaunguage),
          type: .plus,
          model: plusDescription,
          price: nil,
          discount: nil,
          duration: .monthly),
    .init(index: 1,
          name: "Ultra".localized(LanguageConstant.appLaunguage),
          description: "The most favorable tariff. the entire international is available without restrictions".localized(LanguageConstant.appLaunguage),
          type: .ultra,
          model: ultraDescription,
          price: nil,
          discount: nil,
          duration: .monthly),
    .init(index: 2,
          name: "Free".localized(LanguageConstant.appLaunguage),
          description: "The basic tariff is suitable for trying neural networks. There are several free requests".localized(LanguageConstant.appLaunguage),
          type: .free,
          model: freeDescription,
          price: nil,
          discount: nil,
          duration: .monthly),
//MARK: Yearly
    .init(index: 3,
          name: "Plus".localized(LanguageConstant.appLaunguage),
          description: "Increased tariff with additional basic credits and expanded functionality".localized(LanguageConstant.appLaunguage),
          type: .plus,
          model: plusDescription,
          price: nil,
          discount: nil,
          duration: .yearly),
    .init(index: 4,
          name: "Ultra".localized(LanguageConstant.appLaunguage),
          description: "The most favorable tariff. the entire international is available without restrictions".localized(LanguageConstant.appLaunguage),
          type: .ultra,
          model: ultraDescription,
          price: nil,
          discount: nil,
          duration: .yearly),
    .init(index: 5,
          name: "Free".localized(LanguageConstant.appLaunguage),
          description: "The basic tariff is suitable for trying neural networks. There are several free requests".localized(LanguageConstant.appLaunguage),
          type: .free,
          model: freeDescription,
          price: nil,
          discount: nil,
          duration: .yearly),
    ]

let credits = "credits".localized(LanguageConstant.appLaunguage)
let plusDescription: [PayWallDescription] = [
    .init(description: "500 \(credits)",
          included: true),
    .init(description: "5 seconds kling generation".localized(LanguageConstant.appLaunguage),
          included: true),
    .init(description: "Unlimited video downloads".localized(LanguageConstant.appLaunguage),
          included: false),
    .init(description: "Unlimited create albums".localized(LanguageConstant.appLaunguage),
          included: false)
]
let ultraDescription: [PayWallDescription] = [
    .init(description: "1500 \(credits)",
          included: true),
    .init(description: "5/10 seconds kling generation".localized(LanguageConstant.appLaunguage),
          included: true),
    .init(description: "Unlimited video downloads".localized(LanguageConstant.appLaunguage),
          included: true),
    .init(description: "Unlimited create albums".localized(LanguageConstant.appLaunguage),
          included: true)
]
let freeDescription: [PayWallDescription] = [
    .init(description: "20 \(credits)",
          included: true),
    .init(description: "5 seconds kling generation".localized(LanguageConstant.appLaunguage),
          included: true),
    .init(description: "Unlimited video downloads".localized(LanguageConstant.appLaunguage),
          included: false),
    .init(description: "Unlimited create albums".localized(LanguageConstant.appLaunguage),
          included: false)
]

struct CreditsData {
    let index: Int
    let totalValue: String?
    var price: String?
    let discount: Int?
    let mode: CreditsMode
    let credits: Int
}

var creditsData: [CreditsData] = [
        .init(index: 0,
              totalValue: "100",
              price: nil,
              discount: 0,
              mode: .credits100,
              credits: 100),
        .init(index: 1,
              totalValue: "300",
              price: nil,
              discount: 0,
              mode: .credits300,
              credits: 300),
        .init(index: 2,
              totalValue: "500",
              price: nil,
              discount: 0,
              mode: .credits500,
              credits: 500),
        .init(index: 3,
              totalValue: "1K",
              price: nil,
              discount: 0,
              mode: .credits1K,
              credits: 1000)
    ]
