//
//  StandardKeyConversion.swift
//  Threshold
//
//  Created by Leo Feldman on 1/29/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import Foundation

class StandardKeyConversion {
    static var standardsDict: NSDictionary? = nil
    
    static var strokes: [String: String] = ["Freestyle": "Free", "Backstroke": "Back", "Breaststroke": "Breast", "Butterfly": "Fly"]
    static var measurements: [String: String] = ["SCY": "Y", "SCM": "SCM", "LCM": "LCM"]
    
    static var genders: [String: String] = ["BOY": "Boys", "GIRL": "Girls", "MALE": "Boys", "FEMALE": "Girls", "MAN": "Boys", "WOMAN": "Girls"]
    
    class func getKey(event: Event) -> String {
        return String(event.distance) + strokes[event.stroke]! + measurements[event.measurement]!
    }
    
    class func getStandardsDict() -> NSDictionary {
        if standardsDict == nil {
            let resource: NSString = NSBundle.mainBundle().pathForResource("timestandards", ofType: "plist")!
            standardsDict = NSDictionary(contentsOfFile: resource as String)!
        }
        return standardsDict!
    }
    
    class func getTimeStandard(time: Time, finals: Bool) -> String {
        let standardsDict = getStandardsDict()
        
        let birthday = NSUserDefaults.standardUserDefaults().doubleForKey("age")
        let age = Int(NSDate(timeIntervalSince1970: birthday).timeIntervalSinceNow) / (Int(3600*24*365.25))
        
        let genderCheck = NSUserDefaults.standardUserDefaults().objectForKey("gender")
        if birthday == 0 || genderCheck == nil {
            return ""
        }
        
        let gender = (genderCheck as! String).uppercaseString
        
        if genders.keys.contains(gender) {
            let agesLevel = standardsDict.objectForKey(genders[gender]!) as! NSDictionary
            
            var ageTier : String?
            
            if age <= 10 {
                ageTier = "Under10"
            } else if age <= 12 {
                ageTier = "11-12"
            } else if age <= 14 {
                ageTier = "13-14"
            } else if age <= 16 {
                ageTier = "15-16"
            } else if age <= 18 {
                ageTier = "17-18"
            }
            
            if let ageTier = ageTier {
                let eventsLevel = agesLevel.objectForKey(ageTier) as! NSDictionary
                let eventKey = getKey(time.event!)
                if let standardsLevel = eventsLevel.objectForKey(eventKey) {
                    let standards = standardsLevel as! NSDictionary
                    var t: Double?
                    if finals && time.finalsTime != nil {
                        t = Double(time.finalsTime!)
                    } else {
                        t = Double(time.time)
                    }
                    
                    if t <= standards.objectForKey("AAAA") as? Double {
                        return "AAAA"
                    } else if t <= standards.objectForKey("AAA") as? Double {
                        return "AAA"
                    } else if t <= standards.objectForKey("AA") as? Double {
                        return "AA"
                    } else if t <= standards.objectForKey("A") as? Double {
                        return "A"
                    } else if t <= standards.objectForKey("B") as? Double {
                        return "B"
                    } else if t <= standards.objectForKey("BB") as? Double {
                        return "BB"
                    }
                    
                }
            }
        }
        
        return ""
    }
    
}
