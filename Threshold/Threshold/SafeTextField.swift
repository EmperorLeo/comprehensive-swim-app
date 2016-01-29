//
//  SafeTextField.swift
//  Threshold
//
//  Created by Leo Feldman on 1/29/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class SafeTextField: UITextField {


    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == Selector("paste:") {
            return false
        }
        return false
//        return super.canPerformAction(action, withSender: sender)
    }
    
    
}
