//
//  URLBuilder.swift
//  Swim Friend iOS
//
//  Created by Leo Feldman on 12/24/15.
//  Copyright © 2015 Leo and Ray. All rights reserved.
//

import Foundation

class URLBuilder {
    
    var url = "http://" + "ec2-52-23-154-47.compute-1.amazonaws.com:3000"
    
    func base() -> String {
        return localhost()
    }
    
    func localhost() -> String {
        return "localhost:3000"
    }
    
    func AWSEC2() -> String {
        return "ec2-52-23-154-47.compute-1.amazonaws.com:3000"
    }
    
    func users() -> URLBuilder {
        url += "/users"
        return self
    }
    
    func auth() -> URLBuilder {
        url += "/auth"
        return self
    }
    
    func username() -> URLBuilder {
        url += "/username"
        return self
    }

    func clubs() -> URLBuilder {
        url += "/clubs"
        return self
    }

    
    func times() -> URLBuilder {
        url += "/times"
        return self
    }

    
    func goals() -> URLBuilder {
        url += "/goals"
        return self
    }


    func sets() -> URLBuilder {
        url += "/sets"
        return self
    }
    
    func meets() -> URLBuilder {
        url += "/meets"
        return self
    }
    
    func meetId() -> URLBuilder {
        url += "/meetId"
        return self
    }
    
    func event() -> URLBuilder {
        url += "/event"
        return self
    }
    
    func value(value: String) -> URLBuilder {
        url += "/\(value)"
        return self
    }
    
    func token(token: String) -> URLBuilder {
        url += "?token=\(token)"
        return self
    }
    
    func complete() -> String {
        return url
    }
    
}