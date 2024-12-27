//
//  Constants.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 15.10.2024.
//

import Foundation
import UIKit

enum Constants {
    enum TextPaywall {
        static let firstSegmentText = "Monthly"
        static let secondSegmentText = "Yearly Save 20%"
        static let saveText = "Save 20%"
        
        static let headerTitle = "Pricing"
        static let subscribeButtons = "Subscribe"
        static let restoreButton = "Restore"
        static let termsButton = "Terms"
        static let privacyButton = "Privacy"
        
        static let titleButtonPlus = "Plus"
        static let subtitleButtonPlus = "Lots of new features"

        static let infoPriceMonth = "/ month"
        static let infoPriceYear = "/ year"
        
        static let popularViewTitle = "Popular"
        
        static let titleButtonUltra = "Ultra"
        static let subtitleButtonUltra = "Unlocks all functions"
        
        static let titleButtonFree = "Free"
        static let subtitleButtonFree = "Creation of 10 AI videos"
        static let currentPlanTitle = "Current plan"
        
        static let firstInfo = "50 seconds/week of AI generation"
        static let firstUltraInfo = "Unlimited seconds/week of AI generation"//
        static let firstFreeInfo = "10 seconds/week of AI generation"//
        
        
        static let secondInfo = "5 videos in album"
        static let secondUltraInfo = "15 videos in album"//
        static let secondFreeInfo = "Videos in album"//
        
        static let thirdInfo = "Create 5 albums"
        static let thirdUltraInfo = "Create unlimited albums"//
        static let thirdFreeInfo = "Create albums"//
        
        static let fourthInfo = "10 videos saved"
        static let fourthUltraInfo = "Unlimited videos saved"//
        static let fourthFreeInfo = "3 videos saved"//
        
        static let fifthInfo = "Scripting with AI"
        
        static let termsOfUse = "Terms of Use"
        static let privacyPolicy = "Privacy Policy"
        
    }
   
    enum ColorPaywall {
        static let backgrounSegmentView = UIColor(named: "viewCustomColor")
        static let customBlueColor = UIColor(named: "customBlueColor")
        static let viewBackgroundColor = UIColor(named: "backgroundCustom")
        static let darkColorView = UIColor(named: "darkColorView")
        static let colorWhite27 = UIColor(named: "colorWhite27")
        static let colorWhite16 = UIColor(named: "colorWhite16")
        static let colorWhite24 = UIColor(named: "colorWhite24")
        
        static let colorSubscribeButton = UIColor(named: "viewCustomColor")
        static let colorSubtitleButton = UIColor(named: "colorWhite46")
      
    }
    
    enum ImagePaywall {
        static let crownImage = UIImage(named: "crownImage")
        static let included = UIImage(named: "included")
        static let notIncluded = UIImage(named: "notIncluded")
        static let closeButton = UIImage(named: "close")
        static let logoApp = UIImage(named: "logoApp")
        static let arrowLeft = UIImage(named: "arrowLeft")
    }
    
    
    enum TabBarText {
        static let itemsHome = "Home"
        static let itemsAlbums = "Albums"
        static let itemsSettings = "Settings"
    }
}
