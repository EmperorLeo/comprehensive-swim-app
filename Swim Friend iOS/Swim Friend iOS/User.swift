//
//  User.swift
//  Swim Friend iOS
//
//  Created by Leo Feldman on 12/24/15.
//  Copyright © 2015 Leo and Ray. All rights reserved.
//

import Foundation

class User {
    
    var firstName: String
    var lastName: String
    var userName: String
    var birthday: String
    var email: String
    var clubs: [Club] = []
    var meets: [UserMeet] = []
    var goals: [Goals] = []
    var sets: [Sets] = []
    var times: [Time] = []
    
    init(firstName: String, lastName: String, userName: String, birthday: String, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.userName = userName
        self.birthday = birthday
        self.email = email
    }
    
}

class Club {
    var organization: String
    var color: String
    
    init(organization: String, color: String) {
        self.organization = organization
        self.color = color
    }
}

class UserMeet {
    var meetId: String
    var date: String
    var name: String
    var permission: Int
    
    init(meetId: String, date: String, name: String, permission: Int) {
        self.meetId = meetId
        self.date = date
        self.name = name
        self.permission = permission
    }
}

class Goals {
    var meetId: String
    var event: String
    var goalType: String
    var goal: String
    
    init(meetId: String, event: String, goalType: String, goal: String) {
        self.meetId = meetId
        self.event = event
        self.goalType = goalType
        self.goal = goal
    }
}

class Sets {
    var date: String
    var name: String
    var workout: [WorkoutPart] = []
    
    init(date: String, name: String) {
        self.date = date
        self.name = name
    }
}

class Time {
    var event: String
    var performances: [Performance] = []
    
    init(event: String) {
        self.event = event
    }
}

class WorkoutPart {
    var repetitions: Int
    var distance: Int
    var stroke: String
    var interval: String
    
    init(repetitions: Int, distance: Int, stroke: String, interval: String) {
        self.repetitions = repetitions
        self.distance = distance
        self.stroke = stroke
        self.interval = interval
    }
}

class Performance {
    var date: String
    var organizationId: String
    var standard: String
    var time: String
    
    init(date: String, organizationId: String, standard: String, time: String) {
        self.date = date
        self.organizationId = organizationId
        self.standard = standard
        self.time = time
    }
}