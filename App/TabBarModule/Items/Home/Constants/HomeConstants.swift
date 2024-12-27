//
//  Home.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 16.10.2024.
//

import UIKit

enum HomeConstants {
    
    enum HomeText {
        static let recentActivityTitle = "Recent Activity"
        static let savedTitle = "Saved videos"
        static let showMoreTitle = "Show more"
        static let createButtonTitle = "Create a first video"
        static let viewEmptyTitle = "It's empty here yet"
        static let headerTitle = "All saved videos"
        static let upgradeTitle = "Upgrade"
        static let upgradeTitleActive = "Active"
        static let headerCreateTitle = "Create a video"
        static let describePlaceholder = "Describe the video here"
        static let generateButtonTitle = "Generate a video"
        
        static let countDescription = "/30000"
        
        static let pluginTitle = "Workflows & Plugins"
        
        static let pluginFirstTitle = "Basic workflows"
        static let pluginSecondTitle = "Script to video"
        static let pluginThirdTitle = "Youtube Shorts"
        static let pluginFourthTitle = "Instagram Reels"
        
        static let selectFirstPlugin = "Basic workflows:"
        static let selectSecondPlugin = "Script to video:"
        static let selectThirgPlugin = "Youtube Shorts:"
        static let selectFourthPlugin = "Instagram Reels:"
        
        static let infoTitle = "You can describe the video yourself, or use the section Workflows & Plugins"
        static let infoTitleWhite = "Workflows & Plugins"
        static let durationTitle = "Video duration"
        static let durationTitleYouTube = "Youtube shorts duration"
        static let durationTitleInstagram = "Instagram reels duration"
        static let descriptionTitle = "Video description"
        static let musicTitle = "Background music"
        static let aspectRatioTitle = "Video aspect ratio"
        static let saveChanges = "Save changes"
        static let descriptionPlaceholder = "Describe what you want to see in this video"
        static let uploadMusicButton = "Upload from device"
        static let musicPlaceholder = "Example: cheerful"
        
        static let headerTitleAspect = "Select aspect"
        
        static let headerTitleDyration = "Select duration"
        static let firstDurationValue = "15 seconds"
        static let secondDurationValue = "1 minute"
        static let thirdDuratinValue = "5 minutes"
        static let fourthDuratinValue = "10 minutes"
        static let fifthDuratinValue = "15 minutes"
        
        static let firstShortsDurationValue = "15 seconds"
        static let secondShortsDuratinValue = "30 seconds"
        static let thirdShortsDurationValue = "1 minute"
        
        static let otherTimeTitle = "Other time"
        static let minutePlaceholder = "0 min"
        static let secondsPlaceholder = "0 sec"
        static let minuteUnit = "min"
        static let secondsUnit = "sec"
        
        static let titleSkriptToVideo = "Basic video script"
        static let descSkriptToVideo = "Describe the main scenario of your video to better build a logical chain"
        static let AIdescriptionTitle = "Scripting with AI"
        static let AIdescriptionPlaceholder = "Write down the main keys for script"
        
        static let patternDuration = "Video duration"
        static let patternRatio = "aspect ratio"
        static let patternMusic = "music"
        
        static let loaderHeaderTitle = "Generating.."
        static let loaderinfoTitle = "Do not turn off your device or lock the screen"
        
        static let resultHeaderTitle = "Result"
        static let saveVideoButton = "Save video"
        static let skipButtonTitle = "Skip"
        static let resultTitlePlaceholder = "Video title"
        
        static let limitationsScript = "To use this feature, select an Ultra subscription."
        static let limitGenerationThree = "You have reached the limit of 3 videos"
        static let limitGenerationTen = "You have reached the limit of 10 videos"
        static let limitGenerationTime = "You have exhausted the number of minutes to generate a video. They are updated every week."
        
        static let minuteTitle = "minute"
        static let secondsTitle = "seconds"
        
        static let rateViewTitle = "Support our growth, rate us!"
        static let rateTitleYes = "Yes"
        static let rateTitleNo = "No"
        
        
        static let editVideoTitle = "Edit video"
        static let discardTitle = "Discard"
        static let applyTitle = "Apply"
        static let libraryTitle = "Library"
        static let stockTitle = "Stock"
        static let uploadMedia = "Upload media"
        
        static let createVideoSubitle = "Start from scratch"
        static let assetLibraryTitle = "Select from your library"
        static let assetLibraryMessage = "Allow access?"
        static let closeTitle = "Close"
        static let doneTitle = "Done"
        static let loaderTitle = "Generation"
        static let errorTitle = "Error"
        static let errorMessage = "Something went wrong. Please try again later."
    }
    
    enum HomeColor {
        static let backgroundColor = UIColor(named: "backgroundCustom")
        static let colorWhite46 = UIColor(named: "colorWhite46")
        static let customBlueColor = UIColor(named: "customBlueColor")
        static let colorWhite38 = UIColor(named: "colorWhite38")
        static let customGray15 = UIColor(named: "customGray15")
        static let colorWhite65 = UIColor(named: "colorWhite65")
        static let specialGrayColor = UIColor(named: "specialGrayColor")
        static let customGrayColor = UIColor(named: "customGrayColor")
        static let viewCustomColor = UIColor(named: "viewCustomColor")
        static let colorWhite77 = UIColor(named: "colorWhite77")
        static let colorGray14 = UIColor(named: "colorGray14")
        static let customDarkColor = UIColor(named: "customDarkColor")
        
        static let customGrayC4 = UIColor(named: "customGrayC4")
        static let colorWhite8 = UIColor(named: "colorWhite8")
        static let editButtoncolor = UIColor(named: "editButtoncolor")
        static let editViewsColor = UIColor(named: "editViewsColor")
    }
    
    enum HomeImage {
        static let upgradeButton = UIImage(named: "upgradeButton")
        static let createVideoButton = UIImage(named: "createVideoButton")
        static let arrowRight = UIImage(named: "arrowRight")
        static let arrowLeft = UIImage(named: "arrowLeft")
        static let remove = UIImage(named: "removeCustomImage")
        static let infoImage = UIImage(named: "infoImage")
        static let arrowDown = UIImage(named: "arrowDown")
        static let selectImage = UIImage(named: "selectImage")
        static let whiteCrown = UIImage(named: "whiteCrown")
        static let repeatImage = UIImage(named: "repeatImage")
        static let timeImage = UIImage(named: "timeImage")
        static let chevronRight = UIImage(named: "chevronRight")
        static let backgroundActivity = UIImage(named: "backgroundActivity")
        
        static let customLogo = UIImage(named: "customLogo")
        static let starsImage = UIImage(named: "starsImage")
        static let uploadImage = UIImage(named: "uploadImage")
        static let searchImage = UIImage(named: "searchImage")
        static let premiumImage = UIImage(named: "premiumImage")
        static let selectButton = UIImage(named: "selectButton")
        static let miniPlay = UIImage(named: "miniPlay")
        static let stopButton = UIImage(named: "stopButton")
        static let sliderMusik = UIImage(named: "sliderMusik")
    }
    
    enum HomeIntegerValue {
        static let maxTextCount = 30000
    }
 
}
