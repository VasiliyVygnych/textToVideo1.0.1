//
//  AlbumsData.swift
//  CreateAIVideo
//
//  Created by Vasiliy Vygnych on 21.10.2024.
//

import Foundation
import CoreData

@objc(AlbumsData)
public class AlbumsData: NSManagedObject {}
extension AlbumsData {
    @NSManaged public var id: Int16
    @NSManaged public var nameId: String?
    @NSManaged public var nameAlbum: String?
    @NSManaged public var dateOfCreate: Date
    @NSManaged public var addIndex: Int16
}
extension AlbumsData : Identifiable {}

