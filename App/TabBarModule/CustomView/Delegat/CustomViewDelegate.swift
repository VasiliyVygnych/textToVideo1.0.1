//
//  CustomViewDelegate.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 09.11.2024.
//

import Foundation

protocol CustomViewDelegate: AnyObject {
    
    func isHideTabBar(_ bool: Bool)
    func showView() 
}
