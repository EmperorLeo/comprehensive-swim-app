//
//  Time+CoreDataProperties.swift
//  
//
//  Created by Leo Feldman on 1/6/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Time {

    @NSManaged var clubName: String?
    @NSManaged var meetName: String?
    @NSManaged var notes: String?
    @NSManaged var time: NSNumber
    @NSManaged var finalsTime: NSNumber?
    @NSManaged var best: NSNumber?
    @NSManaged var event: Event?
    @NSManaged var meetDate: MeetDate

}
