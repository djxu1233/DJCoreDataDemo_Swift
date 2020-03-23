//
//  DJBook+CoreDataProperties.swift
//  DJCoreDataDemo
//
//  Created by minstone.DJ on 2020/3/23.
//  Copyright © 2020 minstone. All rights reserved.
//
//

import Foundation
import CoreData


extension DJBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DJBook> {
        return NSFetchRequest<DJBook>(entityName: "DJBook")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Int16
    @NSManaged public var page: Int16
    @NSManaged public var color: Int16

}
