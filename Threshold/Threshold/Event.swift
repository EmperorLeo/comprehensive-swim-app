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
