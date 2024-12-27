//
//  SavedVideo.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 21.10.2024.
//

import Foundation
import CoreData

@objc(SavedVideos)
public class SavedVideos: NSManagedObject {}
extension SavedVideos {
    @NSManaged public var id: Int16
    @NSManaged public var title: String?
    @NSManaged public var duration: String?
    @NSManaged public var videoURL: String?
    @NSManaged public var dateOfCreate: Date
    @NSManaged public var previewImage: Data
    @NSManaged public var genType: String?
}
extension SavedVideos : Identifiable {}
