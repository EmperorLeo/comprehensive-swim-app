//
//  SettingsViewController.swift
//  Threshold
//
//  Created by Leo Feldman on 2/15/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThresholdColor.greenColor
        self.tableView.backgroundColor = ThresholdColor.greenColor
        for row in 0...self.tableView.numberOfRowsInSection(0) - 1 {
            themeUIViews([self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0))!])
        }
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
