//
//  MeetDate.swift
//  Threshold
//
//  Created by Leo Feldman on 1/6/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import Foundation
import CoreData


class MeetDate: NSManagedObject, Comparable {

// Insert code here to add functionality to your managed object subclass

}

func <(left: MeetDate, right: MeetDate) -> Bool {
    return left.date.timeIntervalSince1970 < right.date.timeIntervalSince1970
}

func ==(left: MeetDate, right: MeetDate) -> Bool {
    return left.date.timeIntervalSince1970 == right.date.timeIntervalSince1970
}
