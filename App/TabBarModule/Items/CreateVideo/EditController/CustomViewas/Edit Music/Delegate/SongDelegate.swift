//
//  SongDelegate.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 14.11.2024.
//

import Foundation

protocol SongViewDelegate: AnyObject {
    func setIndexPath(_ indexPath: IndexPath)
    func showAndHidePlayers(_ bool: Bool)
    func cellStart()
    func cellPause()
}
