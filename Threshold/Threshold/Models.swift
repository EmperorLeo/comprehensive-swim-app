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
        let event = NSManagedObject(entity: eventEntity!, insertIntoManagedObjectContext: managedContext)
        event.setValue(stroke, forKeyPath: "Stroke")
        event.setValue(distance, forKeyPath: "Distance")
        event.setValue(measurement, forKeyPath: "Measurement")
        do {
            try managedContext.save()
            return true
        } catch {
            return false
        }
    }
    
    
    func editEvent(event: Event) -> Bool {
//        let eventEntity = NSEntityDescription.entityForName("Event", inManagedObjectContext: managedContext)
        let object = managedContext.objectWithID(event.id)
        object.setValue(event.stroke, forKeyPath: "Stroke")
        object.setValue(event.measurement, forKeyPath: "Measurement")
        object.setValue(event.distance, forKeyPath: "Distance")
        do {
            try managedContext.save()
            return true
        } catch {
            return false
        }
    }
    
    func getEvents() -> [Event]? {
        let fetchRequest = NSFetchRequest()
        let eventEntity = NSEntityDescription.entityForName("Event", inManagedObjectContext: managedContext)
        fetchRequest.entity = eventEntity
        var events = [Event]()
        do {
            if let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                for event in fetchResults {
                    events.append(Event(id: event.objectID, stroke: event.valueForKey("Stroke") as! String, distance: event.valueForKey("Distance") as! Int, measurement: event.valueForKey("Measurement") as! String!))
                }
            }
            return events
        } catch {
            return events
        }
    }
    
    
    func removeObject(id: NSManagedObjectID) {
        let object = managedContext.objectWithID(id)
        managedContext.deleteObject(object)
    }
    
}

class Event {
    
    var id: NSManagedObjectID
    var stroke: String
    var distance: Int
    var measurement: String
    
    init(id: NSManagedObjectID, stroke: String, distance: Int, measurement: String) {
        self.id = id
        self.stroke = stroke
        self.distance = distance
        self.measurement = measurement
    }
}