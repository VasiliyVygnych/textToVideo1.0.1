//
//  Enums.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 14.10.2024.
//

import Foundation

enum SubscriptionDuration {
    case monthly
    case yearly
}

enum SubscriptionMode {
    case none
    case free
    case monthlyPlus
    case monthlyUltra
    case yearlyPlus
    case yearlyUltra
}

enum CreditsMode {
    case none
    case credits100
    case credits300
    case credits500
    case credits1K
    
    var index: Int {
        switch self {
        case .none:
            return 0
        case .credits100:
            return 0
        case .credits300:
            return 1
        case .credits500:
            return 2
        case .credits1K:
            return 3
        }
    }
}

enum SubscriptionType {
    case freeAccess
    case monthlyPlus
    case monthlyUltra
    case yearlyPlus
    case yearlyUltra
    
    var value: String {
        switch self {
        case .freeAccess:
            return "Free"
        case .monthlyPlus:
            return "Monthly Plus"
        case .monthlyUltra:
            return "Monthly Ultra"
        case .yearlyPlus:
            return "Yearly Plus"
        case .yearlyUltra:
            return "Yearly Ultra"
        }
    }
}


enum SubscriptionID {
    case monthlyPlus
    case monthlyUltra
    case yearlyPlus
    case yearlyUltra
//MARK: Credits
    case credits100
    case credits300
    case credits500
    case credits1K
    
    var key: String {
        switch self {
        case .monthlyPlus:
            return "monthlyPlusAccess_01"
        case .monthlyUltra:
            return "monthlyUltraAccess_02"
        case .yearlyPlus:
            return "yearlyPlusAccess_03"
        case .yearlyUltra:
            return "yearlyUltraAccess_04"
//MARK: Credits
        case .credits100:
            return "accessToCredits_100"
        case .credits300:
            return "accessToCredits_300"
        case .credits500:
            return "accessToCredits_500"
        case .credits1K:
            return "accessToCredits_1K"
        }
    }
}
