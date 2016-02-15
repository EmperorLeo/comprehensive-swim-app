//
//  GeneralTabBarController.swift
//  Threshold
//
//  Created by Leo Feldman on 2/15/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class GeneralTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = ThresholdColor.redColor
        self.tabBar.tintColor = UIColor.blackColor()
        self.tabBar.translucent = false
        self.tabBar.layer.borderWidth = 1
        self.tabBar.layer.borderColor = ThresholdColor.goldColor.CGColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
