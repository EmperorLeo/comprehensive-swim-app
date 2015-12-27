//
//  MainViewController.swift
//  Swim Friend iOS
//
//  Created by Leo Feldman on 12/17/15.
//  Copyright © 2015 Leo and Ray. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = BLUE_THEME

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
   
    
    @IBAction func logout(sender: UIBarButtonItem) {
        
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "user_token")
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "user_name")
        self.performSegueWithIdentifier("logoutSegue", sender: sender)
    }
    
    
}
