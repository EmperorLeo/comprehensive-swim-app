//
//  UserInfo.swift
//  Swim Friend iOS
//
//  Created by Leo Feldman on 12/24/15.
//  Copyright © 2015 Leo and Ray. All rights reserved.
//

import Foundation

var USER_TOKEN: String {
    get {
        return NSUserDefaults.standardUserDefaults().objectForKey("user_token") as! String
    }
}
var USER_NAME: String {
    get {
        return NSUserDefaults.standardUserDefaults().objectForKey("user_name") as! String
    }
}