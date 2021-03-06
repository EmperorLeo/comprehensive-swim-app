//
//  ManageTimesController.swift
//  Threshold
//
//  Created by Leo Feldman on 12/30/15.
//  Copyright © 2015 Leo. All rights reserved.
//

import UIKit

class ManageTimesController: UITableViewController {

    
    var events: [Event]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThresholdColor.greenColor
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadEvents()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(events == nil) {
            return 0
        }
        return events!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let events = self.events {
            if let cell = tableView.dequeueReusableCellWithIdentifier("SwimEventCell") {
                let event = events[indexPath.row]
                (cell.viewWithTag(1) as! UILabel).text = event.toString()
                let numTimes = Models().getTimes(event).count
                var description = "times"
                if(numTimes == 1) {
                    description = "time"
                }
                (cell.viewWithTag(2) as! UILabel).text! = "\(String(numTimes)) \(description)"
                cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
                cell.contentView.layer.borderWidth = 1
                let color = getTableCellColor(indexPath)
                (cell.viewWithTag(1) as! UILabel).backgroundColor = color
                (cell.viewWithTag(2) as! UILabel).backgroundColor = color
                cell.contentView.layer.backgroundColor = color.CGColor
                (cell.viewWithTag(3) as! UIImageView).image = getImageForStroke(event.stroke)
                
                let leftBorder = CALayer()
                leftBorder.backgroundColor = UIColor.blackColor().CGColor
                leftBorder.frame = CGRectMake(0, 0, 1, 70)
                (cell.viewWithTag(3) as! UIImageView).layer.addSublayer(leftBorder)
                
                return cell
            }
        }
        reloadEvents()
        return UITableViewCell()
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let events = self.events {
            performSegueWithIdentifier("AddTimeSegue", sender: events[indexPath.row])
        }
    }
    
    func reloadEvents() {
        events = Models().getEvents()
        events!.sortInPlace()
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddEventSegue" {
            (segue.destinationViewController as! AddEventController).manageTimesController = self
        }
        if segue.identifier == "AddTimeSegue" {
            (segue.destinationViewController as! AddTimeController).event = sender as? Event
        }
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
