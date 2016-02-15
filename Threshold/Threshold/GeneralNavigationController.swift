//
//  GeneralNavigationController.swift
//  Threshold
//
//  Created by Leo Feldman on 2/15/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class GeneralNavigationController: UINavigationController {

    var bottomBorder: CALayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barStyle = .Default
        navigationBar.tintColor = UIColor.blackColor()
        navigationBar.barTintColor = ThresholdColor.redColor
        navigationBar.translucent = false
//        navigationBar.layer.borderWidth = 1
//        navigationBar.layer.borderColor = ThresholdColor.goldColor.CGColor
        bottomBorder = CALayer()
        bottomBorder!.frame = CGRectMake(0, navigationBar.frame.size.height - 1, navigationBar.frame.size.width, 1)
        bottomBorder!.backgroundColor = ThresholdColor.goldColor.CGColor
        navigationBar.layer.addSublayer(bottomBorder!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceRotated:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deviceRotated(notification: NSNotification) {
        
        
        bottomBorder!.frame = CGRectMake(0, navigationBar.frame.size.height - 1, navigationBar.frame.size.width, 1)
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
