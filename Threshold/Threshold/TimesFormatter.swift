//
//  TimesFormatter.swift
//  Threshold
//
//  Created by Leo Feldman on 2/7/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class TimesFormatter: NSNumberFormatter {

    override func stringFromNumber(number: NSNumber) -> String? {
        
        let time = Double(number)
        
        let roundedTime = Int(time)
        var minutes = String(roundedTime / 60)
        var seconds = String(roundedTime % 60)
        var millis = String(Int((time - Double(roundedTime)) * 100))
        
        if minutes.characters.count == 1 {
            minutes = "0" + minutes
        }
        
        if seconds.characters.count == 1 {
            seconds = "0" + seconds
        }
        
        if millis.characters.count == 1 {
            millis = "0" + millis
        }

        return minutes + ":" + seconds + "." + millis
        
    }
    
}
