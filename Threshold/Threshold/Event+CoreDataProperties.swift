//
//  Event+CoreDataProperties.swift
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

extension Event {

    @NSManaged var distance: NSNumber
    @NSManaged var measurement: String
    @NSManaged var stroke: String
    @NSManaged var goal: NSNumber?
    @NSManaged var times: NSSet?

}
