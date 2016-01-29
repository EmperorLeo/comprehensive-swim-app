//
//  Event.swift
//  Threshold
//
//  Created by Leo Feldman on 1/5/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import Foundation
import CoreData

@objc(Event)
class Event: NSManagedObject, Comparable {

    var goalTime: String {
     
        get {
            
            if(self.goal == nil || self.goal == 0) {
                return ""
            }
            
            let time = Double(self.goal!)
            
            let roundedTime = Int(time)
            let minutes = String(roundedTime / 60)
            var seconds = String(roundedTime % 60)
            var millis = String(Int((time - Double(roundedTime)) * 100))
            
            if(seconds.characters.count == 1) {
                seconds = "0" + seconds
            }
            if(millis.characters.count == 1) {
                millis = "0" + millis
            }
            
            
            return "\(minutes):\(seconds).\(millis)"

        }
        
    }
    
    
    func toString() -> String {
        return "\(distance)\(measurement) \(stroke)"
    }

}

func <(left: Event, right: Event) -> Bool {
    if(left.stroke == right.stroke) {
        
        if(left.measurement == right.measurement) {
            
            let leftDist = Int(left.distance)
            let rightDist = Int(right.distance)
            return leftDist < rightDist
            
        }
        else {
            return left.measurement < right.measurement
        }
        
    }
    else {
        return left.stroke < right.stroke
    }
}

func ==(left: Event, right: Event) -> Bool {
    return left.stroke == right.stroke && left.measurement == right.measurement && Int(left.distance) == Int(right.distance)
}
