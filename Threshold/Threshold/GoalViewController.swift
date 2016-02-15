//
//  GoalViewController.swift
//  Threshold
//
//  Created by Leo Feldman on 1/26/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class GoalViewController: UITableViewController, UITextFieldDelegate {

    var events = [Event]()
    var selectedIndex: NSIndexPath?
    let fakeTextView = UITextField()
    let goalPicker = TimePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThresholdColor.greenColor
        events = Models().getEvents().sort()
        
//        tableView!.registerClass(GoalsCell.self, forCellReuseIdentifier: "goalCell")
        
        
        
        let toolbar = UIToolbar()
        toolbar.barStyle = .Black
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "donePressed:")
        doneButton.tintColor = UIColor.blueColor()
        toolbar.setItems([doneButton], animated: true)
        
        self.view.addSubview(fakeTextView)
        
        fakeTextView.inputView = goalPicker
        fakeTextView.inputAccessoryView = toolbar
        fakeTextView.delegate = self
        toolbar.sizeToFit()

//        self.tableView.contentInset = UIEdgeInsetsMake(0, -40, 0, 0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath
        fakeTextView.becomeFirstResponder()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("goalCell") as! GoalsCell? {
            let event = events[indexPath.row]
        
            cell.eventName = event.toString()
        
            if let goal = event.goal {
                let goalTime = Double(goal)
                cell.goal = event.goalTime
                var goalMet = false
                for time in event.times!.allObjects as! [Time] {
                    if Double(time.time) <= goalTime {
                        goalMet = true
                        break
                    }
                }
                cell.goalMet = goalMet
            } else {
                cell.goal = ""
            }
            return cell
        
        }
        
        return UITableViewCell()
        
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 30
//    }
    
    func donePressed(sender: UIBarButtonItem) {
        fakeTextView.resignFirstResponder()
        tableView.cellForRowAtIndexPath(selectedIndex!)?.setSelected(false, animated: true)
        
        do {
            events[selectedIndex!.row].goal = goalPicker.getSelectedTime()
            try Models().managedContext.save()
        } catch {
            print("error")
        }
//        Models().setGoal(events[selectedIndex!.row], goal: goalPicker.getSelectedTime())
        
        selectedIndex = nil
        
        self.tableView.reloadData()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let text = tableView.cellForRowAtIndexPath(selectedIndex!)!.detailTextLabel!.text!
        if !text.characters.isEmpty {
            goalPicker.setSelectedTimeUsingString(text)
        }
        else {
            goalPicker.setSelectedTime(0)
        }
    }

}
