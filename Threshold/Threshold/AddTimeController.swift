//
//  AddTimeController.swift
//  Threshold
//
//  Created by Leo Feldman on 12/30/15.
//  Copyright © 2015 Leo. All rights reserved.
//

import UIKit

class AddTimeController: UIViewController, UITextFieldDelegate {

    var event: Event?
    var dateFormatter: NSDateFormatter?
    
    var timePicker: TimePicker?
    var finalsTimePicker: TimePicker?
    var datePicker: UIDatePicker?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var finalsTime: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var meetField: UITextField!
    @IBOutlet weak var clubField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var prelimsFinalsChooser: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = event!.toString()
        
        dateFormatter = NSDateFormatter()
        dateFormatter!.dateFormat = "MM-dd-yyyy"
        
        timePicker = TimePicker()
        timeField.inputView = timePicker!
        finalsTimePicker = TimePicker()
        finalsTime.inputView = finalsTimePicker!
        datePicker = UIDatePicker()
        datePicker!.datePickerMode = .Date
        dateField.inputView = datePicker
        datePicker!.maximumDate = NSDate()

        let timeToolbar = makeToolbar("finishTime")
        let finalsTimeToolbar = makeToolbar("finishFinalsTime")
        let dateToolbar = makeToolbar("finishDate")
        timeField.inputAccessoryView = timeToolbar
        finalsTime.inputAccessoryView = finalsTimeToolbar
        dateField.inputAccessoryView = dateToolbar
        timeToolbar.sizeToFit()
        finalsTimeToolbar.sizeToFit()
        dateToolbar.sizeToFit()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let meetFieldText = userDefaults.valueForKey("meetField") {
            meetField.text = meetFieldText as! String
        }
        if let clubFieldText = userDefaults.valueForKey("clubField") {
            clubField.text = clubFieldText as! String
        }
        
        timeField.delegate = self
        finalsTime.delegate = self
        dateField.delegate = self
        meetField.delegate = self
        clubField.delegate = self
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func finishTime(sender: AnyObject?) {
        let timeInSeconds = timePicker!.getSelectedTimeString()
        timeField.text = timeInSeconds
        timeField.resignFirstResponder()
//        let interval = NSTimeInterval(timeInSeconds)
    }
    
    func finishFinalsTime(sender: AnyObject?) {
        let timeInSeconds = finalsTimePicker!.getSelectedTimeString()
        finalsTime.text = timeInSeconds
        finalsTime.resignFirstResponder()
    }
    
    func finishDate(sender: AnyObject?) {
        let dateString = dateFormatter!.stringFromDate(datePicker!.date)
        dateField.text = dateString
        dateField.resignFirstResponder()
    }

    
    func makeToolbar(selector: String) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.barStyle = .Black
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("\(selector):"))
        doneButton.tintColor = UIColor.blueColor()
        toolbar.setItems([doneButton], animated: true)
        return toolbar
    }
    
    @IBAction func timeTypeChanged(sender: UISegmentedControl) {
        if prelimsFinalsChooser.selectedSegmentIndex == 0 {
            finalsTime.hidden = true
            timeField.placeholder = "Time"
        } else if prelimsFinalsChooser.selectedSegmentIndex == 1 {
            finalsTime.hidden = false
            timeField.placeholder = "Prelims Time"
        }
        
        
    }
    
    @IBAction func addPressed(sender: UIBarButtonItem) {
        var requiredFields = [timeField, dateField]
        if(prelimsFinalsChooser.selectedSegmentIndex == 1) {
            requiredFields.append(finalsTime)
        }
        var canSave = true
        for field in requiredFields {
            if field.text!.isEmpty {
                field.layer.borderWidth = 1
                field.layer.borderColor = UIColor.redColor().CGColor
                canSave = false
            }
        }
        if(canSave) {
            canSave = Models().dateAlreadyHasTime(dateFormatter!.dateFromString(dateField.text!)!, event: event!)
            if(!canSave) {
                let alert = UIAlertController(title: "Time Exists", message: "You already have a time for this event on this date.", preferredStyle: .Alert)
                let alertAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(alertAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }

        if(canSave) {
            var finalsTimeDouble: Double?
            if(prelimsFinalsChooser.selectedSegmentIndex == 1) {
                finalsTimeDouble = finalsTimePicker!.getSelectedTime()
            }
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            
            userDefaults.setValue(meetField.text, forKey: "meetField")
            userDefaults.setValue(clubField.text, forKey: "clubField")
            
            Models().addTime(event!, time: timePicker!.getSelectedTime(), finalsTime: finalsTimeDouble, date: dateFormatter!.dateFromString(dateField.text!)!, meetName: trimToNull(meetField.text), clubName: trimToNull(clubField.text), notes: trimToNull(notesTextView.text))
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    //I placed the following fun in the utilityfunctions.swift file
//    private func trimToNull(str: String?) -> String? {
//        if let str = str {
//            if str.isEmpty {
//                return nil
//            }
//            else {
//                return str
//            }
//        }
//        return str
//    }
    
    func keyboardWillShow(notification: NSNotification) {
        //TODO
        let info: NSDictionary = notification.userInfo!
        let kbSize = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue.size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize!.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        //TODO
        let contentInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets

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
