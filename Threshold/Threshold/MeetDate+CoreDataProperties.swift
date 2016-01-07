//
//  MeetDate+CoreDataProperties.swift
//  Threshold
//
//  Created by Leo Feldman on 1/6/16.
//  Copyright © 2016 Leo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MeetDate {

    @NSManaged var date: NSDate
    @NSManaged var times: NSSet?

}
