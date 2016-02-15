//
//  SocialLoginController.swift
//  Threshold
//
//  Created by Leo Feldman on 2/7/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire
import TwitterKit

class SocialLoginController: UIViewController, FBSDKLoginButtonDelegate {

    
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var stackOne: UIStackView!
    @IBOutlet weak var stackTwo: UIStackView!
    @IBOutlet weak var stackThree: UIStackView!
    
    @IBOutlet weak var facebookProfilePic: UIImageView!
    @IBOutlet weak var twitterProfilePic: UIImageView!
    @IBOutlet weak var instagramProfilePic: UIImageView!
    
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    @IBOutlet weak var fbNameLabel: UILabel!
    @IBOutlet weak var fbEmailLabel: UILabel!
    
    @IBOutlet weak var twitterStack: UIStackView!
    var twitterLoginButton: TWTRLogInButton?
    @IBOutlet weak var twitterNameLabel: UILabel!
    @IBOutlet weak var twitterHandleLabel: UILabel!
    var twitterAPIClient: TWTRAPIClient?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThresholdColor.greenColor
        fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        // Do any additional setup after loading the view.
        if FBSDKAccessToken.currentAccessToken() != nil {
            setFacebookFields()
        }
        
        twitterLoginButton = TWTRLogInButton(logInCompletion: { session, error in
            
            if let error = error {
                print("twitter login failed")
            }
            else {
                self.twitterAPIClient = TWTRAPIClient(userID: session!.userID)
                self.setTwitterFields()
            }

            
        })
        
        
        twitterStack.removeArrangedSubview(twitterNameLabel)
        twitterStack.removeArrangedSubview(twitterHandleLabel)
        
        twitterStack.addArrangedSubview(twitterLoginButton!)
        twitterStack.addArrangedSubview(twitterNameLabel)
        twitterStack.addArrangedSubview(twitterHandleLabel)
        if let twitterUserID = Twitter.sharedInstance().session()?.userID {
            twitterAPIClient = TWTRAPIClient(userID: twitterUserID)
            setTwitterFields()

        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if let error = error {
            print("rip")
        }
        else if result.isCancelled {
            
            return
        }
        else {
            setFacebookFields()
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        facebookProfilePic.image = nil
        fbNameLabel.text = "Name Label"
        fbEmailLabel.text = "Email Label"
    }
    
    
    
    func setFacebookFields() {
        
        let fbUserID = FBSDKAccessToken.currentAccessToken().userID
        
        let graphRequestParams: [String: String] = ["fields": "email, name, first_name, last_name"]
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: graphRequestParams)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if let error = error {
                print("graph request failed")
            }
            
            else {
                
                self.fbNameLabel.text = result.valueForKey("name") as? String
                self.fbEmailLabel.text = result.valueForKey("email") as? String
                
            }
        
        
        
        })
        
        
        let url = "http://graph.facebook.com/\(fbUserID!)/picture?type=large"
        
        Alamofire.request(.GET, url).response() { _, _, data, _ in
            let image = UIImage(data: data! as NSData)
            self.facebookProfilePic.image = image
            
        }

    }
    
    func setTwitterFields() {
        
        twitterAPIClient!.loadUserWithID(twitterAPIClient!.userID!) { (user, error) -> Void in
            
            let url = user!.profileImageURL
            self.twitterNameLabel.text = user?.name
            
            Alamofire.request(.GET, url).response() { _, _, data, _ in
                let image = UIImage(data: data! as NSData)
                self.twitterProfilePic.image = image
                
            }

            
        }
//        twitterLoginButton?.setAttributedTitle(NSAttributedString(string: "Log Out"), forState: .Normal)
//        twitterLoginButton?.setImage(nil, forState: .Normal)
        self.twitterHandleLabel.text = "@" + Twitter.sharedInstance().session()!.userName
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func orientationChanged(notif: NSNotification) {
        
        let orientation = UIDevice.currentDevice().orientation
        
        if orientation.isPortrait {
            mainStackView.axis = .Vertical
            stackOne.axis = .Horizontal
            stackTwo.axis = .Horizontal
            stackThree.axis = .Horizontal
        }
        
        else if orientation.isLandscape {
            mainStackView.axis = .Horizontal

            stackOne.axis = .Vertical
            stackTwo.axis = .Vertical
            stackThree.axis = .Vertical
        }
        
        
    }
    

}
