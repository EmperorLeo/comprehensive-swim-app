//
//  AddEventController.swift
//  Threshold
//
//  Created by Leo Feldman on 12/30/15.
//  Copyright © 2015 Leo. All rights reserved.
//

import UIKit

class AddEventController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var setEventButton: UIButton!
    @IBOutlet weak var distance: UITextField!
    @IBOutlet weak var stroke: UITextField!
    @IBOutlet weak var measurement: UITextField!
    
    var eventPicker: EventPicker?
    var fakeTextField: UITextField?
    
    var manageTimesController: ManageTimesController?
    var fields: [UITextField]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fakeTextField = UITextField()
        fakeTextField?.hidden = true
        self.view.addSubview(fakeTextField!)
        distance.delegate = self
        distance.tintColor = UIColor.clearColor()
        stroke.delegate = self
        measurement.delegate = self
        eventPicker = EventPicker()
        eventPicker!.backgroundColor = UIColor.whiteColor()
        
        fakeTextField!.inputView = eventPicker
        let toolbar = UIToolbar()
        toolbar.barStyle = .Black
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("doneButtonClicked:"))
        doneButton.tintColor = UIColor.blueColor()
        toolbar.setItems([doneButton], animated: true)
        fakeTextField!.inputAccessoryView = toolbar
        toolbar.sizeToFit()
        fields = [distance, stroke, measurement]

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveClicked(sender: UIButton) {
        
        var proceed = true
        for field in fields! {
            if field.text!.isEmpty {
                proceed = false
                field.layer.borderColor = UIColor.redColor().CGColor
                field.layer.borderWidth = 1
            }
        }
        
        if(proceed) {
            Models().addEvent(stroke.text!, distance: Int(distance.text!)!, measurement: measurement.text!)
            manageTimesController!.reloadEvents()
            self.dismissViewControllerAnimated(true, completion: {})
        }
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return false
    }
    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        textField.layer.borderColor = UIColor.clearColor().CGColor
//    }
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    @IBAction func setEventClicked(sender: UIButton) {
        fakeTextField!.becomeFirstResponder()
        for field in fields! {
            field.layer.borderColor = UIColor.clearColor().CGColor
        }
    }
    
    func doneButtonClicked(sender: AnyObject?) {
        distance.text = eventPicker!.getSelectedDistance()
        stroke.text = eventPicker!.getSelectedStroke()
        measurement.text = eventPicker!.getSelectedMeasurement()
        fakeTextField!.resignFirstResponder()
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
