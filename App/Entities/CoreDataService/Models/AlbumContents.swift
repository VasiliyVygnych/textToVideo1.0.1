//
//  AlbumContents.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 30.10.2024.
//

import Foundation
import CoreData

@objc(AlbumContents)
public class AlbumContents: NSManagedObject {}
extension AlbumContents {
    @NSManaged public var id: Int16
    @NSManaged public var addIndex: Int16
    @NSManaged public var idNameAlbum: String?
    
    @NSManaged public var title: String?
    @NSManaged public var duration: String?
    @NSManaged public var videoURL: String?
    @NSManaged public var previewImage: Data
}
extension AlbumContents : Identifiable {}
