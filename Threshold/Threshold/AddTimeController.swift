//
//  AddTimeController.swift
//  Threshold
//
//  Created by Leo Feldman on 12/30/15.
//  Copyright © 2015 Leo. All rights reserved.
//

import UIKit

class AddTimeController: UIViewController {

    var event: Event?
    var dateFormatter: NSDateFormatter?
    
    var timePicker: TimePicker?
    var datePicker: UIDatePicker?
    
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var meetField: UITextField!
    @IBOutlet weak var clubField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = event!.toString()
        
        dateFormatter = NSDateFormatter()
        dateFormatter!.dateFormat = "MM-dd-yyyy"
        
        timePicker = TimePicker()
        timeField.inputView = timePicker!
        datePicker = UIDatePicker()
        datePicker!.datePickerMode = .Date
        dateField.inputView = datePicker

        let timeToolbar = makeToolbar("finishTime")
        let dateToolbar = makeToolbar("finishDate")
        timeField.inputAccessoryView = timeToolbar
        dateField.inputAccessoryView = dateToolbar
        timeToolbar.sizeToFit()
        dateToolbar.sizeToFit()
        // Do any additional setup after loading the view.
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
    
    @IBAction func addPressed(sender: UIBarButtonItem) {
        let requiredFields = [timeField, dateField]
        var canSave = true
        for field in requiredFields {
            if field.text!.isEmpty {
                field.layer.borderWidth = 1
                field.layer.borderColor = UIColor.redColor().CGColor
                canSave = false
            }
        }
        if(canSave) {
            Models().addTime(event!, time: timePicker!.getSelectedTime(), date: datePicker!.date.timeIntervalSince1970, meetName: meetField.text, clubName: clubField.text, notes: notesTextView.text)
            navigationController!.popViewControllerAnimated(true)
        }
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
