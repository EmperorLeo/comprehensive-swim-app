//
//  SignUpController.swift
//  Swim Friend iOS
//
//  Created by Leo Feldman on 12/25/15.
//  Copyright © 2015 Leo and Ray. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!

    var fields: [UITextField] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.hidden = false
        fields = [firstNameField, lastNameField, usernameField, passwordField, passwordConfirmField, emailField, birthdayField]
        self.view.backgroundColor = BLUE_THEME
        for field in fields {
            field.delegate = self
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardDidHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWasShown(aNotification: NSNotification) {
//        let deviceOrientation: UIDeviceOrientation = UIDevice.currentDevice().orientation
        let keyboardSize: CGSize = (aNotification.userInfo! as NSDictionary).objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue.size
        //outdated info, keyboard width and height autochange
//        if(UIDeviceOrientationIsLandscape(deviceOrientation)) {
//            let tempSize = keyboardSize
//            keyboardSize.height = tempSize.width
//            keyboardSize.width = tempSize.height
//        }
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var activeField: UITextField?
        for field in fields {
            if(field.isFirstResponder()) {
                activeField = field
                break
            }
        }
        
        if(activeField == nil) {
            activeField = firstNameField
        }
        
        var frame = scrollView.frame
        frame.size.height -= keyboardSize.height
        print(activeField!.frame.origin.x)
        print(activeField!.frame.origin.y)
        let activePoint: CGPoint = self.view!.convertPoint(activeField!.frame.origin, fromCoordinateSpace: activeField!)
        if(!CGRectContainsPoint(frame, activePoint)) {
            let point  = CGPointMake(0, activePoint.y - keyboardSize.height)
            scrollView.setContentOffset(point, animated: true)
        }
    }

    func keyboardWillHide(aNotification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.layer.borderColor = UIColor.clearColor().CGColor
        textField.layer.borderWidth = 0
    }
    
    @IBAction func signUpPressed(sender: UIBarButtonItem) {
        var shouldSegue = true
        for field in fields {
            if(field.text!.isEmpty) {
                shouldSegue = false
                field.layer.borderColor = UIColor.redColor().CGColor
                field.layer.borderWidth = 2
            }
        }
        if(passwordField.text! != passwordConfirmField.text!) {
            shouldSegue = false
            passwordField.layer.borderColor = UIColor.redColor().CGColor
            passwordConfirmField.layer.borderColor = UIColor.redColor().CGColor
            passwordField.layer.borderWidth = 2
            passwordConfirmField.layer.borderWidth = 2
        }
        if(shouldSegue) {
            postAttempt()
        }
    }
    
    func postAttempt() {
        let postUserParams: [String: AnyObject]? = ["firstName":firstNameField.text!,"lastName":lastNameField.text!,"userName":usernameField.text!,"password":passwordField.text!,"birthday":birthdayField.text!,"email":emailField.text!]
        Alamofire.request(.POST, URLBuilder().users().complete(), parameters: postUserParams).validate().responseJSON { response in
            
            switch(response.result) {
            case .Success(let data):
                self.authUser()
            case .Failure(let error):
                self.usernameField.layer.borderColor = UIColor.redColor().CGColor
                self.usernameField.layer.borderWidth = 2
            }
            
        }
    }
    
    func authUser() {
        let postAuthParams: [String: AnyObject]? = ["userName":usernameField.text!,"password":passwordField.text!]
        Alamofire.request(.POST, URLBuilder().users().auth().complete(), parameters: postAuthParams).validate().responseJSON { response in
            
            switch(response.result) {
            case .Success(let data):
                NSUserDefaults.standardUserDefaults().setObject(self.usernameField.text!, forKey: "user_name")
                NSUserDefaults.standardUserDefaults().setObject(data.objectForKey("token") as! String, forKey: "user_token")
            case .Failure(let error):
                let alert = UIAlertController(title: "User created", message: "An error prevented successful login.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.performSegueWithIdentifier("backToLoginSegue", sender: alert)}))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if(segue.identifier == "backToLoginSegue") {
//            segue.destinationViewController.navigationController!.navigationBar.hidden = true
//            segue.destinationViewController.navigationItem.hidesBackButton = true
//            segue.destinationViewController.navigationController!.navigationBarHidden = true
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
