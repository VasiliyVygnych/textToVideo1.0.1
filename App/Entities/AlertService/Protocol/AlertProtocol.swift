//
//  AlertProtocol.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 16.10.2024.
//

import UIKit

protocol AlertManagerProtocol {
    
    func requestError(title: String,
                      message: String,
                      action: UIAlertAction) -> UIAlertController
    
    
}
