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
    var genderImage = UIImageView(frame: CGRectMake(0, 0, 30, 30))
    var ageView = UILabel(frame: CGRectMake(0, 0, 30, 30))
    
    let datePicker = UIDatePicker()
    let dateFormat = NSDateFormatter()
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThresholdColor.greenColor
        themeUIViews([firstName, lastName, gender, age, genderImage, ageView])
        genderImage.hidden = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

        firstName.delegate = self
        lastName.delegate = self
        gender.delegate = self
        gender.rightViewMode = .Always
        gender.rightView = genderImage
        gender.addTarget(self, action: "genderFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
        
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
        displayGenderIcon(gender.text)
        ageView.hidden = true
        ageView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        ageView.textAlignment = .Center
        let birthday = defaults.doubleForKey("age")
        if birthday != 0 {
            age.text = dateFormat.stringFromDate(NSDate(timeIntervalSince1970: birthday))
            displayAgeIcon(age.text)
        }
        age.rightView = ageView
        age.rightViewMode = .Always
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dateDoneEditing(sender: AnyObject?) {
        age.resignFirstResponder()
        age.text = dateFormat.stringFromDate(datePicker.date)
        displayAgeIcon(age.text)
    }
    
    func genderFieldChanged(sender: UITextField) {
        genderImage.hidden = true
        displayGenderIcon(sender.text)
    }
    
    func displayAgeIcon(birthday: String?) {
        
        if birthday == nil || birthday!.isEmpty {
            self.ageView.hidden = true
            return
        }
        
        let now = dateFormat.stringFromDate(NSDate())
        let dateSplit = birthday!.split("-")
        let nowDateSplit = now.split("-")
        
        let age = Int(nowDateSplit[2])! - Int(dateSplit[2])! - 1
        
        if Int(nowDateSplit[0]) > Int(dateSplit[0]) {
            self.ageView.text = String(age + 1)
        } else if Int(nowDateSplit[0]) < Int(dateSplit[0]) {
            self.ageView.text = String(age)
        } else {
            
            if Int(nowDateSplit[1]) >= Int(dateSplit[1]) {
                self.ageView.text = String(age + 1)
            }
            else {
                self.ageView.text = String(age)
            }
        }
        self.ageView.hidden = false
        
        
        
    }
    
    func displayGenderIcon(gender: String?) {
        if gender == "Male" {
            genderImage.hidden = false
            genderImage.frame = CGRectMake(0, 0, self.gender.frame.height, self.gender.frame.height)
            genderImage.image = UIImage(named: "maleicon")
        } else if self.gender.text == "Female" {
            genderImage.hidden = false
            genderImage.frame = CGRectMake(0, 0, self.gender.frame.height, self.gender.frame.height)
            genderImage.image = UIImage(named: "maleicon")
        }
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
