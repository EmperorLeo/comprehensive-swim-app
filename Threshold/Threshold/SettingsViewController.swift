//
//  SettingsViewController.swift
//  Threshold
//
//  Created by Leo Feldman on 2/15/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var resetTimes: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThresholdColor.greenColor
        self.tableView.backgroundColor = ThresholdColor.greenColor
        for row in 0...self.tableView.numberOfRowsInSection(0) - 1 {
            themeUIViews([self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0))!])
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "resetAllTimes:")
        resetTimes.addGestureRecognizer(tapGesture)
        
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
    
    func resetAllTimes(sender: AnyObject?) {
        let alert = UIAlertController(title: "WARNING", message: "All saved times will be deleted and unrecoverable.", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Destructive) { void in
            Models().hardReset()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
