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
    
    func getEvents() -> [Event] {
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
    
    
    func addTime(event: Event, time: Double, finalsTime: Double?, date: NSDate, meetName: String?, clubName: String?, notes: String?) -> Bool {
        let timeEntity = NSEntityDescription.entityForName("Time", inManagedObjectContext: managedContext)
        let timeObject = Time(entity: timeEntity!, insertIntoManagedObjectContext: managedContext)
        timeObject.time = NSNumber(double: time)
        if let finalsTime = finalsTime {
            timeObject.finalsTime = finalsTime
        }
        timeObject.meetDate = getDate(date)!
        timeObject.meetName = meetName
        timeObject.clubName = clubName
        timeObject.notes = notes
        timeObject.event = event
        
//        var best: Bool? = true
        let times = getTimes(event).sort()
        
        var bestTimeToDate: Double?
        
        for someTime in times {
            
            let timeToCheck = getBestOfTwo(Double(someTime.time), two: Double(someTime.finalsTime ?? someTime.time))

            if bestTimeToDate != nil {
                
                if bestTimeToDate > timeToCheck {
                    someTime.best = true
                    bestTimeToDate = timeToCheck
                }
                else if bestTimeToDate == timeToCheck {
                    someTime.best = nil
                }
                else {
                    someTime.best = false
                }
                
            }
            else {
                someTime.best = nil
                bestTimeToDate = timeToCheck
            }
            
        }
        
        //old best time code
//        if times.count == 1 {
//            best = nil
//        }
//        else {
//            
//            //best time of prelims finals for time to add
//            let bestOfTwo = getBestOfTwo(time, two: finalsTime)
//            
//            for otherTime in times {
//                
//                //best time of prelims finals for other time
//                let otherTimeBest = getBestOfTwo(Double(otherTime.time), two: Double(otherTime.finalsTime ?? otherTime.time))
//                
//                if(otherTime == timeObject) {
//                    continue
//                }
//                
//                if(otherTimeBest < bestOfTwo && otherTime.meetDate.date.timeIntervalSince1970 <= date.timeIntervalSince1970) {
//                    best = false
//                }
//                
//                if(otherTimeBest == bestOfTwo && otherTime.meetDate.date.timeIntervalSince1970 <= date.timeIntervalSince1970 && best == true) {
//                    best = nil
//                }
//                
//                if(otherTimeBest > bestOfTwo && otherTime.meetDate.date.timeIntervalSince1970 >= date.timeIntervalSince1970) {
//                    otherTime.best = false
//                }
//                
//                if(otherTimeBest == bestOfTwo && otherTime.meetDate.date.timeIntervalSince1970 >= date.timeIntervalSince1970 && otherTime.best == true) {
//                    otherTime.best = nil
//                }
//                                
//            }
//        }
//        
//        timeObject.best = best
        
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
    
    func getDate(date: NSDate) -> MeetDate? {
        let fetchRequest = NSFetchRequest()
        let dateEntity = NSEntityDescription.entityForName("MeetDate", inManagedObjectContext: managedContext)
        fetchRequest.entity = dateEntity
        print(date.timeIntervalSince1970)
        fetchRequest.predicate = NSPredicate(format: "date == %@", date)
        
        do {
            if let fetchResult = try managedContext.executeFetchRequest(fetchRequest) as? [MeetDate] {
                if(fetchResult.count > 0) {
                    return fetchResult[0]
                }
                else {
                    let dateEntity = NSEntityDescription.entityForName("MeetDate", inManagedObjectContext:managedContext)
                    let dateObject = MeetDate(entity: dateEntity!, insertIntoManagedObjectContext: managedContext)
                    dateObject.date = date
                    //                try managedContext.save()
                    return dateObject
                }
            }
            else {
                return nil
            }
        } catch {
            print("error")
            return nil
        }
        
    }
    
    func getDates() -> [MeetDate] {
        
        let fetchRequest = NSFetchRequest()
        let dateEntity = NSEntityDescription.entityForName("MeetDate", inManagedObjectContext: managedContext)
        fetchRequest.entity = dateEntity

        var dates = [MeetDate]()
        do {
            if let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [MeetDate] {
                dates = fetchResults
            }
            return dates
        } catch {
            print("error")
            return dates
        }
        
        
    }
    
    func dateAlreadyHasTime(date: NSDate, event: Event) -> Bool {
//        let fetchRequest = NSFetchRequest()
//        let dateEntity = NSEntityDescription.entityForName("MeetDate", inManagedObjectContext: managedContext)
//        fetchRequest.entity = dateEntity
//        fetchRequest.predicate = NSPredicate(format: "", date)
        if let date = getDate(date) {
            do {
                try managedContext.save()
            } catch {
                print("error")
            }
            if(date.times == nil || date.times!.count == 0) {
                return true
            }
            for time in date.times!.allObjects as! [Time] {
                if time.event!.objectID == event.objectID {
                    return false
                }
            }
//            let fetchRequest = NSFetchRequest()
//            let timeEntity = NSEntityDescription.entityForName("Time", inManagedObjectContext: managedContext)
//            fetchRequest.entity = timeEntity
//            fetchRequest.predicate = NSPredicate(format: "%@ CONTAINS ", date.times!)
        }
        return true
    }
    
    
    func removeObject(id: NSManagedObjectID) {
        let object = managedContext.objectWithID(id)
        managedContext.deleteObject(object)
    }
    
    //helpers
    func getBestOfTwo(one: Double, two: Double?) -> Double {
        if(two == nil) {
            return one
        }
        else {
            return min(one, two!)
        }
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