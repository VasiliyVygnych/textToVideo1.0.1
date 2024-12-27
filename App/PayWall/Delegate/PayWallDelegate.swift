//
//  PayWallDelegate.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 23.12.2024.
//

import Foundation

protocol PayWallDelegate: AnyObject {
    func didCompletePayment(_ type: SubscriptionMode)
    func buyCredit(_ mode: CreditsMode)
}
