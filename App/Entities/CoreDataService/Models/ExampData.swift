//
//  ExampData.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 13.12.2024.
//

import Foundation
import CoreData

@objc(ExampData)
public class ExampData: NSManagedObject {}
extension ExampData {
    @NSManaged public var id: Int16
    @NSManaged public var title: String?
    @NSManaged public var videoURL: String?
}
extension ExampData : Identifiable {}