//
//  LoginViewController.swift
//  Swim Friend iOS
//
//  Created by Leo Feldman on 12/17/15.
//  Copyright © 2015 Leo and Ray. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var basicLoginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginEmbeddedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //design
        self.view.backgroundColor = BLUE_THEME
        basicLoginButton.backgroundColor = BUTTOM_THEME
        signUpButton.backgroundColor = BUTTOM_THEME
        loginEmbeddedView.backgroundColor = BLUE_THEME
        
        //login logic
        let userName: String? = NSUserDefaults.standardUserDefaults().objectForKey("user_name") as! String?
        let token: String? = NSUserDefaults.standardUserDefaults() .objectForKey("user_token") as! String?
        if(userName != nil && token != nil) {
            Alamofire.request(.GET, URLBuilder().users().username().value(userName!).token(token!).complete()).validate().responseJSON { response in
                if(response.result.isSuccess) {
                    self.performSegueWithIdentifier("LoginSegue", sender: nil)
                } else {
                    self.usernameField.text = userName
                }
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func basicLoginPressed(sender: UIButton) {
        
        let username = usernameField.text!
        let password = passwordField.text!
        let authParams = ["userName": username, "password": password]
        
        Alamofire.request(.POST, URLBuilder().users().auth().complete(), parameters: authParams).validate().responseJSON { response in
            if(response.result.isSuccess) {
                let JSON = response.result.value
                let token = JSON?.objectForKey("token") as! String
                NSUserDefaults.standardUserDefaults().setObject(username, forKey: "user_name")
                NSUserDefaults.standardUserDefaults().setObject(token, forKey: "user_token")
                self.performSegueWithIdentifier("LoginSegue", sender: sender)
            }
        }
        
    }
    
    @IBAction func signUpPressed(sender: UIButton) {
        self.performSegueWithIdentifier("LoginSegue", sender: sender)
    }
}
