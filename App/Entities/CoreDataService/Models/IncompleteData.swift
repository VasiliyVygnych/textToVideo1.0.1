//
//  IncompleteData.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 18.10.2024.
//

import Foundation
import CoreData

@objc(IncompleteData)
public class IncompleteData: NSManagedObject {}
extension IncompleteData {
    @NSManaged public var id: Int16
    @NSManaged public var credits: Int16
    @NSManaged public var sreateSelector: String?
    
    @NSManaged public var pluginMode: String?
    @NSManaged public var descriptions: String?
    @NSManaged public var descriptionsAI: String?
    @NSManaged public var musicName: String?
    @NSManaged public var duration: String?
    @NSManaged public var ratio: String?
    @NSManaged public var dateOfCreate: Date
    @NSManaged public var done: Bool
    
    @NSManaged public var selectImage: Data
    @NSManaged public var strUrl: String?
    @NSManaged public var styleMode: String?
}
extension IncompleteData : Identifiable {}

