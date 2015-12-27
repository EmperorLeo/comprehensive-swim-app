//
//  MeetsTableViewController.swift
//  Swim Friend iOS
//
//  Created by Leo Feldman on 12/17/15.
//  Copyright © 2015 Leo and Ray. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MeetsTableViewController: UITableViewController {

    //Testing variables
//    var meetsArray = ["YMCA Invitational", "HULA Invitational" ,"USRY", "YSSC", "Regionals"]
    var meetsArray: [UserMeet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Alamofire.request(.GET, URLBuilder().users().username().value(USER_NAME).token(USER_TOKEN).complete()).responseJSON {
            response in
            switch(response.result) {
            case .Success(let data):
                let json = JSON(data)
                for (index,meetJSON):(String,JSON) in json["meets"] {
                    let userMeet = UserMeet(meetId: meetJSON["_id"].stringValue, date: "", name: meetJSON["name"].stringValue, permission: meetJSON["permission"].intValue)
                    self.meetsArray.append(userMeet)
                }
                self.tableView.reloadData()
            case .Failure(let error):
                let alert = UIAlertController(title: "Meet load failed", message: "The end date should not be earlier than the start date.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    
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
        return meetsArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("meetIdentifier", forIndexPath: indexPath)
        cell.textLabel!.text = meetsArray[indexPath.row].name
        cell.detailTextLabel!.text = getPermission(meetsArray[indexPath.row].permission)
        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("SwimmerMeetSegue", sender: indexPath)
    }

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

    
    func getPermission(i: Int) -> String {
        if(i == 0) {
            return "Admin"
        } else if(i == 1) {
            return "Timer"
        } else {
            return "Swimmer"
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(sender is NSIndexPath) {
            let row = (sender as! NSIndexPath).row
            let meetName = meetsArray[row].name
            segue.destinationViewController.navigationItem.title = meetName
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
