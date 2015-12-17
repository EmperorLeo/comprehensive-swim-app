//
//  LoginViewController.swift
//  Swim Friend iOS
//
//  Created by Leo Feldman on 12/17/15.
//  Copyright © 2015 Leo and Ray. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var basicLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = BLUE_THEME
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func basicLoginPressed(sender: UIButton) {
        self.performSegueWithIdentifier("LoginSegue", sender: sender)
    }
    
}
