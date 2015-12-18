//
//  SwimmerMeetViewController.swift
//  Swim Friend iOS
//
//  Created by Leo Feldman on 12/17/15.
//  Copyright © 2015 Leo and Ray. All rights reserved.
//

import UIKit

class SwimmerMeetViewController: UIViewController {
    
    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var eventNum: UILabel!
    
    @IBOutlet weak var heatNum: UILabel!
    
    @IBOutlet weak var userEventName: UILabel!
    
    @IBOutlet weak var userEventNum: UILabel!
    
    @IBOutlet weak var userHeatNum: UILabel!
    
    @IBOutlet weak var clock: DigitalClock!
    
    var timer: NSTimer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventName.text = "Girls 200 Yard Medley Relay"
        eventNum.text = "1"
        heatNum.text = "1"
        
        userEventName.text = "Boys 100 Yard Butterfly"
        userEventNum.text = "10"
        userHeatNum.text = "2"
        

        clock.backgroundColor = BLUE_THEME
        clock.setTimer(3600)
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "update", userInfo: nil, repeats: true)
    }
    
    func update() {
        clock.decrement()
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
