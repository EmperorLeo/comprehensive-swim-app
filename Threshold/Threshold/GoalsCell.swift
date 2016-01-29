//
//  GoalsCell.swift
//  Threshold
//
//  Created by Leo Feldman on 1/12/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class GoalsCell: UITableViewCell {

    
    var eventName: String {
        set {
            self.textLabel!.text = newValue
        }
        get {
            return self.eventName
        }
    }
    
    
    var goal: String {
        set {
            self.detailTextLabel!.text = newValue
        }
        get {
            return self.goal
        }
    }
    
    
    var goalMet: Bool {
        get {
            return self.goalMet
        }
        set {
            if newValue {
                self.accessoryType = .Checkmark
            } else {
                self.accessoryType = .None
            }
        }
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
