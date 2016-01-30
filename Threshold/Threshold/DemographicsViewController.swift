//
//  DemographicsViewController.swift
//  Threshold
//
//  Created by Leo Feldman on 1/11/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class DemographicsViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let datePicker = UIDatePicker()
    let dateFormat = NSDateFormatter()
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

        firstName.delegate = self
        lastName.delegate = self
        gender.delegate = self
        
        datePicker.datePickerMode = .Date
        dateFormat.dateFormat = "MM-dd-yyyy"
        
        let toolbar = UIToolbar()
        toolbar.barStyle = .Black
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dateDoneEditing:")
        doneButton.tintColor = UIColor.blueColor()
        toolbar.setItems([doneButton], animated: true)

        
        age.inputView = datePicker
        age.inputAccessoryView = toolbar
        toolbar.sizeToFit()
        
        
        firstName.text = defaults.valueForKey("firstName") as? String
        lastName.text = defaults.valueForKey("lastName") as? String
        gender.text = defaults.valueForKey("gender") as? String
        let birthday = defaults.doubleForKey("age")
        if birthday != 0 {
            age.text = dateFormat.stringFromDate(NSDate(timeIntervalSince1970: birthday))
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dateDoneEditing(sender: AnyObject?) {
        age.resignFirstResponder()
        age.text = dateFormat.stringFromDate(datePicker.date)
    }
    
    func keyboardWillShow(aNotification: NSNotification) {
        
        let info = aNotification.userInfo!
        let boardSize = info[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let contentInsets = UIEdgeInsetsMake(0, 0, boardSize.height, 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
    }
    
    func keyboardWillHide(aNotification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    override func viewDidDisappear(animated: Bool) {
        defaults.setValue(firstName.text!, forKey: "firstName")
        defaults.setValue(lastName.text!, forKey: "lastName")
        defaults.setValue(gender.text!, forKey: "gender")
        
        if !age.text!.characters.isEmpty {
            let birthday = dateFormat.dateFromString(age.text!)!.timeIntervalSince1970
            defaults.setDouble(birthday, forKey: "age")
        } else {
            defaults.setDouble(0, forKey: "age")
        }
//        defaults.setInteger(Int(age.text!)!, forKey: "age")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
