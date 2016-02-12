//
//  UtilityFunctions.swift
//  Threshold
//
//  Created by Leo Feldman on 2/8/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import Foundation

func trimToNull(str: String?) -> String? {
    
    if let s = str {
        
        if s.isEmpty {
            return nil
        }
        
    }
    
    return str
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

    
}