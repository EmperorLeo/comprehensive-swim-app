//
//  MeetEventsController.swift
//  Swim Friend iOS
//
//  Created by Leo Feldman on 12/24/15.
//  Copyright © 2015 Leo and Ray. All rights reserved.
//

import UIKit

class MeetEventsController: UIViewController {

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
        (segue.destinationViewController as! MeetSwimmersController).meet = meet
    }

}
