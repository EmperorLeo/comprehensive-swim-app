//
//  UtilityFunctions.swift
//  Threshold
//
//  Created by Leo Feldman on 2/8/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import Foundation
import UIKit

var tableCellColor: UIColor = UIColor(red: 211.0/255, green: 211.0/255, blue: 211.0/255, alpha: 1.0)
var altTableCellColor: UIColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 250.0/255.0, alpha: 1.0)
var dataLineBlue = UIColor(red: 114.0/255, green: 147.0/255, blue: 203.0/255, alpha: 1.0)
var dataPointBlue = UIColor(red: 57.0/255, green: 106.0/255, blue: 177.0/255, alpha: 1.0)


func trimToNull(str: String?) -> String? {
    
    if let s = str {
        
        if s.isEmpty {
            return nil
        }
        
    }
    
    return str
}

func getTableCellColor(indexPath: NSIndexPath) -> UIColor {
    
    if indexPath.row%2==0 {
        return tableCellColor
    }
    else {
        return altTableCellColor
    }
    
}

func getImageForStroke(stroke: String) -> UIImage? {
    
    var image: UIImage?
    var gender = NSUserDefaults.standardUserDefaults().objectForKey("gender") as? String
    
    if gender?.uppercaseString == "FEMALE" || gender?.uppercaseString == "GIRL" || gender?.uppercaseString == "WOMAN" {
        gender = "female"
    }
    else {
        gender = "male"
    }
    
    
    if stroke == "Freestyle" {
        image = UIImage(named: "free\(gender!)")
    } else if stroke == "Backstroke" {
        image = UIImage(named: "back\(gender!)")
    } else if stroke == "Breaststroke" {
        image = UIImage(named: "br\(gender!)")
    } else if stroke == "Butterfly" {
        image = UIImage(named: "fly\(gender!)")
    } else if stroke == "Corkscrew" {
        image = UIImage(named: "corkscrew")
    }
    else {
        image = UIImage(named: "swim\(gender!)")
    }
    
    return image
}

extension String {
    
    func indexesOfString(target: String) -> [Int] {
    
        var returnInts: [Int] = []
        
        if target.characters.count > self.characters.count || target == "" {
            return returnInts
        }
//        var startIndex = 0
//        var endIndex = target.characters.count - 1
        
        var startIndex = self.startIndex
        var startIndexInt = 0
        var endIndex = self.startIndex.advancedBy(target.characters.count - 1)
        var endIndexInt = target.characters.count - 1
        
        while endIndexInt < self.characters.count {
            
            let substring = self[startIndex...endIndex]
            if substring == target {
                returnInts.append(startIndexInt)
            }
            
            startIndex = startIndex.advancedBy(1)
            endIndex = endIndex.advancedBy(1)
            startIndexInt++
            endIndexInt++
        }
        
        
        return returnInts
    }
    
    func split(regex: String) -> Array<String> {
        do{
            let regEx = try NSRegularExpression(pattern: regex, options: NSRegularExpressionOptions())
            let stop = "<SomeStringThatYouDoNotExpectToOccurInSelf>"
            let modifiedString = regEx.stringByReplacingMatchesInString (self, options: NSMatchingOptions(), range: NSMakeRange(0, characters.count), withTemplate:stop)
            return modifiedString.componentsSeparatedByString(stop)
        } catch {
            return []
        }
    }
    
    
    func getSwimTime() -> Double? {
        
        let splitOne = self.split(":")
        let splitTwo = self.split("\\.")
        
        if splitTwo.count != 2 {
            return nil
        }
        
        var time: Double = 0
        if splitOne.count == 2 {
            time+=(Double(splitOne[0])! * 60)
            time+=(Double(splitOne[1].split("\\.")[0])!)
        }
        else {
            time+=(Double(splitTwo[0])!)
        }
        time+=(Double(splitTwo[1])! / 100)
        
        return time
    }
    

    
}