//
//  AppData.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 15.10.2024.
//

import Foundation
import CoreData

@objc(AppData)
public class AppData: NSManagedObject {}
extension AppData {
    @NSManaged public var id: Int16
    @NSManaged public var dateOfSubscripe: Date
    
    @NSManaged public var creditsCount: Int16
    
    @NSManaged public var freeGenerationTime: Double
    @NSManaged public var plusGenerationTime: Double
    @NSManaged public var albumLimitUltra: Int16
    @NSManaged public var albumLimitPlus: Int16
    @NSManaged public var savedLimit: Int16
    
    
    @NSManaged public var subscripeType: String?
    
    @NSManaged public var isLogin: Bool
    
    @NSManaged public var freeIsActive: Bool
    
    @NSManaged public var plusMounthlyActive: Bool
    @NSManaged public var plusYearlyActive: Bool
    
    @NSManaged public var ultraMounthlyActive: Bool
    @NSManaged public var ultraYearlyActive: Bool
    
    @NSManaged public var isSubscripe: Bool
}
extension AppData : Identifiable {}
