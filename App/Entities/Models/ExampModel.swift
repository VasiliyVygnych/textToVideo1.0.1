//
//  ExampModel.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 13.12.2024.
//

import Foundation

struct ExampModel: Codable {
    let id: Int
    let videoURL: String
    let prompt: String
    let imageURL: String?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case videoURL = "video_url"
        case prompt
        case imageURL = "image_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
