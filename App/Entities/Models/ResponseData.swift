//
//  ResponseData.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 23.10.2024.
//

import Foundation

struct ResponseData: Codable {
    let id: String
    let assets: Assets
    let modified: String
    let title, created, finishedTime: String
    let archived: Bool
    let status, category, user, organization: Int

    enum CodingKeys: String, CodingKey {
        case id, assets, modified
        case title, created
        case finishedTime = "finished_time"
        case archived, status, category, user, organization
    }
}
struct Assets: Codable {
    let urls: [String]
}
