//
//  Time.swift
//  
//
//  Created by Leo Feldman on 1/6/16.
//
//

import Foundation
import CoreData
import UIKit

@objc(Time)
class Time: NSManagedObject, Comparable {

// Insert code here to add functionality to your managed object subclass
    var timeColor: UIColor {
        get {
            if let best = best {
                let isBest = Bool(best)
                if(isBest) {
                    return UIColor(red: 3.0/255, green: 166.0/255, blue: 120.0/255, alpha: 1.0)
                }
                else {
                    return UIColor(red: 192.0/255, green: 57.0/255, blue: 43.0/255, alpha: 1.0)
                }
            }
            else {
                return UIColor(red: 245.0/255, green: 171.0/255, blue: 53.0/255, alpha: 1.0)
            }
        }
    }
    
}

func <(left: Time, right: Time) -> Bool {
    //sorts by actual time
//    let bestLeft = min(Double(left.time), Double(left.finalsTime ?? left.time))
//    let bestRight = min(Double(right.time), Double(right.finalsTime ?? right.time))
//    return bestLeft < bestRight
    
    //sorts by meetdate
    return left.meetDate < right.meetDate

}

func ==(left: Time, right: Time) -> Bool {
    //sorts by actual time
//    let bestLeft = min(Double(left.time), Double(left.finalsTime ?? left.time))
//    let bestRight = min(Double(right.time), Double(right.finalsTime ?? right.time))
//    return bestLeft == bestRight
    
    //sorts by meetdate
    return left.meetDate == right.meetDate
}

