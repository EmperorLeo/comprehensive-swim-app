//
//  Time+CoreDataProperties.swift
//  Threshold
//
//  Created by Leo Feldman on 1/5/16.
//  Copyright © 2016 Leo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Time {

    @NSManaged var meetName: String?
    @NSManaged var clubName: String?
    @NSManaged var time: NSNumber
    @NSManaged var date: NSNumber
    @NSManaged var notes: String?
    @NSManaged var event: Event

}
