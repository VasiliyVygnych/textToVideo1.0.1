//
//  TextToVideoData.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 06.12.2024.
//

import UIKit

struct TextToVideoData {
    let duration: String?
    let ratio: CropEnum
    let description: String?
    let image: UIImage?
    let strUrl: String?
    let models: String?
    let type: ModelsToCreate
    let durationType: DurationGenerate
    let credits: Int
}
