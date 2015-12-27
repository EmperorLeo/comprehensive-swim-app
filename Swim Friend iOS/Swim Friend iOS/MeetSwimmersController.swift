//
//  MeetSwimmersController.swift
//  Swim Friend iOS
//
//  Created by Leo Feldman on 12/24/15.
//  Copyright © 2015 Leo and Ray. All rights reserved.
//

import UIKit
import Alamofire

class MeetSwimmersController: UIViewController {

    var meet: Meet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let meetPostParams: [String: AnyObject] = ["name": meet!.name, "country": meet!.country, "state": meet!.state!, "city": meet!.city, "meetType": meet!.meetType]
        Alamofire.request(.POST, URLBuilder().meets().token(NSUserDefaults.standardUserDefaults().objectForKey("user_token") as! String).complete(), parameters: meetPostParams).validate().responseJSON { response in
            if(response.result.isSuccess) {
                let JSON = response.result.value
                let userPostParams: [String: AnyObject] = ["meetId":JSON?.objectForKey("id") as! String, "name": self.meet!.name, "permission": 0]
                //This next request NEEDS to happen, in order to sync up an admin to his/her meet instance
                Alamofire.request(.POST, URLBuilder().users().value(NSUserDefaults.standardUserDefaults().objectForKey("user_name") as! String).meets().token(NSUserDefaults.standardUserDefaults().objectForKey("user_token") as! String).complete(), parameters: userPostParams)
            }
        }
        
        
    }

}
