//
//  CategoryDelegate.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 09.12.2024.
//

import UIKit

protocol CategoryViewDelegate: AnyObject {
    func didSelectCategory(_ category: String?,
                           image: UIImage?)
}
