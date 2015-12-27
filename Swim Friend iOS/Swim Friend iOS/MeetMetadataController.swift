//
//  MeetMetadataController.swift
//  Swim Friend iOS
//
//  Created by Leo Feldman on 12/24/15.
//  Copyright © 2015 Leo and Ray. All rights reserved.
//

import UIKit

class MeetMetadataController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var meetNameField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var meetTypeField: UITextField!
    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var startDateSet: UIButton!
    @IBOutlet weak var endDateField: UITextField!
    @IBOutlet weak var endDateSet: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var largeMiddleStack: UIStackView!
    
    var formatter: NSDateFormatter =  NSDateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = BLUE_THEME
        largeMiddleStack.backgroundColor = BLUE_THEME
        startDateField.delegate = self
        endDateField.delegate = self
        startDateSet.backgroundColor = BUTTON_THEME
        endDateSet.backgroundColor = BUTTON_THEME
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        datePicker.minimumDate = NSDate()
        datePicker.maximumDate = NSDate(timeIntervalSinceNow: 63072000)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func startDateSetPressed(sender: UIButton) {
        let startDate = datePicker.date
        if(!endDateField.text!.isEmpty && startDate.compare(formatter.dateFromString(endDateField.text!)!) == NSComparisonResult.OrderedDescending) {
            let alert = UIAlertController(title: "Bad Start Date", message: "The start date should not be later than the end date.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        } else {
            startDateField.text = formatter.stringFromDate(startDate)
        }
    }
    
    @IBAction func endDateSetPressed(sender: UIButton) {
        let endDate = datePicker.date
        if(startDateField.text!.isEmpty) {
            let alert = UIAlertController(title: "Start Date Empty", message: "Please set a start date before you set the end date.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        }
        else if(endDate.compare(formatter.dateFromString(startDateField.text!)!) == NSComparisonResult.OrderedAscending) {
            let alert = UIAlertController(title: "Bad End Date", message: "The end date should not be earlier than the start date.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        }
        else {
            endDateField.text = formatter.stringFromDate(endDate)
        }

    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return false
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        var shouldSegue = true
        let fields = [meetNameField, countryField, cityField, meetTypeField, startDateField, endDateField]
        for field in fields {
            if(field.text!.isEmpty) {
                field.layer.borderColor = UIColor.redColor().CGColor
                shouldSegue = false
            }
        }
        return shouldSegue
    }
    


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let meet = Meet(meetId: "", name: meetNameField.text!, country: countryField.text!, state: stateField.text, city: cityField.text!, admin: "", meetType: meetTypeField.text!, live: false)
        ((segue.destinationViewController) as! MeetEventsController).meet = meet
        
    }

}
