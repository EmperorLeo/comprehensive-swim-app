//
//  USASwimmingViewController.swift
//  Threshold
//
//  Created by Leo Feldman on 1/30/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class USASwimmingViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let request = NSURLRequest(URL: NSURL(string: "http://www.usaswimming.org/DesktopDefault.aspx?TabId=1470&Alias=Rainbow&Lang=en-US")!)
        webView.loadRequest(request)
        
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
