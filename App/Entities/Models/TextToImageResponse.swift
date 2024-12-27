//
//  TextToImageResponse.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 12.12.2024.
//

import Foundation

struct TextToImageStatus: Codable {
    let requestID, prompt: String
    let imageURL: String?
    let status, duration, model: String

    enum CodingKeys: String, CodingKey {
        case requestID = "request_id"
        case prompt
        case imageURL = "image_url"
        case status, duration, model
    }
}

struct TextToImageProgress: Codable {
    let status: String
    let progress: Int
    let prompt: String

    enum CodingKeys: String, CodingKey {
        case status, progress
        case prompt
    }
}
struct TextToImageResponse: Codable {
    let status: String
    let progress: Int
    let fileURL: String
    let prompt: String

    enum CodingKeys: String, CodingKey {
        case status, progress
        case fileURL = "file_url"
        case prompt
    }
}
