//
//  ScriptData.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 27.11.2024.
//

import Foundation

struct ScriptData: Codable {
    let gptResult: GPTResult

    enum CodingKeys: String, CodingKey {
        case gptResult = "gpt_result"
    }
}
struct GPTResult: Codable {
    let language, prompt: String
}
