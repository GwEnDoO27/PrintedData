//
//  Userdata+CoreDataProperties.swift
//  PrintedData
//
//  Created by Gwendal Benard on 06/09/2024.
//
//

import Foundation
import CoreData


extension Userdata {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Userdata> {
        return NSFetchRequest<Userdata>(entityName: "Userdata")
    }

    @NSManaged public var cube: Float
    @NSManaged public var gramms: Int64
    @NSManaged public var metre: Float
    @NSManaged public var printime: Date?
    @NSManaged public var projectname: String?
    @NSManaged public var todaydate: Date?

}

extension Userdata : Identifiable {

}
