//
//  Meet.swift
//  Swim Friend iOS
//
//  Created by Leo Feldman on 12/24/15.
//  Copyright © 2015 Leo and Ray. All rights reserved.
//

import Foundation

class Meet {
    var meetId: String
    var name: String
    var country: String
    var state: String?
    var city: String
    var admin: String
    var meetType: String
    var live: Bool
    var events: [SwimmerEvent] = []
    var swimmers: [SwimmerInMeet] = []
    var timers: [Timer] = []
    var currentEvent = 1;
    var currentHeat = 1;
    
    init(meetId: String, name: String, country: String, state: String, city: String, admin: String, meetType: String, live: Bool) {
        self.meetId = meetId
        self.name = name
        self.country = country
        self.state = state
        self.city = city
        self.admin = admin
        self.meetType = meetType
        self.live = live
    }
    
    init(meetId: String, name: String, country: String, city: String, admin: String, meetType: String, live: Bool) {
        self.meetId = meetId
        self.name = name
        self.country = country
        self.city = city
        self.admin = admin
        self.meetType = meetType
        self.live = live
    }

}

class MeetEvent {
    
    var name: String
    var eventNum: Int
    var heats: Int
    var stroke: String
    var distance: Int
    var measurement: String
    var ageRange: String
    var gender: Int
    
    init(name: String, eventNum: Int, heats: Int, stroke: String, distance: Int, measurement: String, ageRange: String, gender: Int) {
        self.name = name
        self.eventNum = eventNum
        self.heats = heats
        self.stroke = stroke
        self.distance = distance
        self.measurement = measurement
        self.ageRange = ageRange
        self.gender = gender
    }
}

class SwimmerInMeet {
    var firstName: String
    var lastName: String
    var swimmerIds: [String] = [] //not sure about this one
    var events: [SwimmerEvent] = []
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

class SwimmerEvent {
    var num: Int
    var heat: Int
    var lane: Int
    var seedTime: String
    
    init(num: Int, heat: Int, lane: Int, seedTime: String) {
        self.num = num
        self.heat = heat
        self.lane = lane
        self.seedTime = seedTime
    }
    
}

class Timer {
    var userId: String
    var lane: Int
    
    init(userId: String, lane: Int) {
        self.userId = userId
        self.lane = lane
    }
}