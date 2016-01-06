//
//  Models.swift
//  Threshold
//
//  Created by Leo Feldman on 12/30/15.
//  Copyright © 2015 Leo. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Models {
    
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func addEvent(stroke: String, distance: Int, measurement: String) -> Bool {
        let eventEntity = NSEntityDescription.entityForName("Event", inManagedObjectContext: managedContext)
        let event = Event(entity: eventEntity!, insertIntoManagedObjectContext: managedContext)
        event.setValue(stroke, forKeyPath: "stroke")
        event.setValue(distance, forKeyPath: "distance")
        event.setValue(measurement, forKeyPath: "measurement")
        do {
            try managedContext.save()
            return true
        } catch {
            return false
        }
    }
    
    
//    func editEvent(event: Event) -> Bool {
////        let eventEntity = NSEntityDescription.entityForName("Event", inManagedObjectContext: managedContext)
//        let object = managedContext.objectWithID(event.id)
//        object.setValue(event.stroke, forKeyPath: "stroke")
//        object.setValue(event.measurement, forKeyPath: "measurement")
//        object.setValue(event.distance, forKeyPath: "distance")
//        do {
//            try managedContext.save()
//            return true
//        } catch {
//            return false
//        }
//    }
    
    func getEvents() -> [Event]? {
        let fetchRequest = NSFetchRequest()
        let eventEntity = NSEntityDescription.entityForName("Event", inManagedObjectContext: managedContext)
        fetchRequest.entity = eventEntity
        var events = [Event]()
        do {
            if let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [Event] {
                events = fetchResults
//                for event in fetchResults {
//                    events.append(Event(id: event.objectID, stroke: event.valueForKey("stroke") as! String, distance: event.valueForKey("distance") as! Int, measurement: event.valueForKey("measurement") as! String!))
//                }
            }
            return events
        } catch {
            return events
        }
    }
    
    
    func addTime(event: Event, time: Double, date: Double, meetName: String?, clubName: String?, notes: String?) -> Bool {
        let timeEntity = NSEntityDescription.entityForName("Time", inManagedObjectContext: managedContext)
        let timeObject = Time(entity: timeEntity!, insertIntoManagedObjectContext: managedContext)
        timeObject.time = NSNumber(double: time)
        timeObject.date = NSNumber(double: date)
        timeObject.meetName = meetName
        timeObject.clubName = clubName
        timeObject.notes = notes
        timeObject.event = event
        
        
        do {
            try managedContext.save()
            return true
        } catch {
            return false
        }
    }
    
    func getTimes(event: Event) -> [Time] {
        if let times = event.times {
            return times.allObjects as! [Time]
        }
        return [Time]()
    }
    
    
    func removeObject(id: NSManagedObjectID) {
        let object = managedContext.objectWithID(id)
        managedContext.deleteObject(object)
    }
    
}

//class Event: NSManagedObject {
//    
//    @NSManaged var stroke: String
//    @NSManaged var distance: Int16
//    @NSManaged var measurement: String
//    @NSManaged var times: NSSet
//    
////    init(id: NSManagedObjectID, stroke: String, distance: Int, measurement: String) {
////        self.id = id
////        self.stroke = stroke
////        self.distance = distance
////        self.measurement = measurement
////    }
//    
//    func toString() -> String {
//        return "\(distance)\(measurement) \(stroke)"
//    }
//}
//
//class Time: NSManagedObject {
//    
//   @NSManaged var event: Event
//   @NSManaged var time: Int32 //seconds
//   @NSManaged var date: NSDate //time since 1970
//   @NSManaged var meetName: String?
//   @NSManaged var clubName: String?
//   @NSManaged var notes: String?
//    
////    init(id: NSManagedObjectID, event: NSURL, time: Int32, date: NSDate, meetName: String?, clubName: String?, notes: String?) {
////        self.id = id
////        self.event = event
////        self.time = time
////        self.date = date
////        self.meetName = meetName
////        self.clubName = clubName
////        self.notes = notes
////    }
//    
//    func toString() -> String {
//        return "\(time)"
//    }
//    
//}