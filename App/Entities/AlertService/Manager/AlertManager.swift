//
//  AlertManager.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 16.10.2024.
//

import UIKit

class AlertManager: AlertManagerProtocol {
    
     func requestError(title: String,
                      message: String,
                      action: UIAlertAction) -> UIAlertController {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let cancel = action
        alert.addAction(cancel)
        return alert
    }
    
}
