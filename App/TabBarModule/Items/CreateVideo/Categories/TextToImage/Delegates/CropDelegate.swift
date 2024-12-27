//
//  CropDelegate.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 06.12.2024.
//

import UIKit

protocol CropViewDelegate: AnyObject {
    func didCropImage(_ image: UIImage?, type: CropEnum)
}
