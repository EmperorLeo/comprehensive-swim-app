//
//  SwimmerSearchMeetsController.swift
//  Swim Friend iOS
//
//  Created by Leo Feldman on 12/24/15.
//  Copyright © 2015 Leo and Ray. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SwimmerSearchMeetsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var countrySearch: UISearchBar!
    @IBOutlet weak var citySearch: UISearchBar!
    @IBOutlet weak var nameSearch: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var meetTableView: UITableView!
    
    var currentMeetsSet = NSMutableSet()
    var queriedMeets: [Meet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        meetTableView.delegate = self
        meetTableView.dataSource = self
        loadUserMeets()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUserMeets() {
        Alamofire.request(.GET, URLBuilder().users().username().value(USER_NAME).token(USER_TOKEN).complete()).validate().responseJSON { response in
            switch response.result {
                case .Success(let data):
                    let json = JSON(data)
                    for (index,meet):(String, JSON) in json["meets"] {
                        self.currentMeetsSet.addObject(meet["meetId"].stringValue)
                    }
                    self.loadAllMeets()
                
                case .Failure(let error):
                    self.showLoadMeetFail()
            }
            
        }
    }
    
    func loadAllMeets() {
        Alamofire.request(.GET, URLBuilder().meets().token(USER_TOKEN).complete()).validate().responseJSON { response in
            switch response.result {
                case .Success(let data):
                    let json = JSON(data)
                    for(_, meetJson):(String, JSON) in json {
                        let meet: Meet = Meet(meetId: meetJson["_id"].stringValue, name: meetJson["name"].stringValue, country: meetJson["country"].stringValue, state: meetJson["state"].string, city: meetJson["city"].stringValue, admin: meetJson["admin"].stringValue, meetType: meetJson["meetType"].stringValue, live: meetJson["live"].boolValue)
                        if(!self.currentMeetsSet.containsObject(meet.meetId)) {
                            self.queriedMeets.append(meet)
                        }
                    }
                    self.meetTableView.reloadData()
                case .Failure(let error):
                    self.showLoadMeetFail()
            }
            
        }
    }
    
    func showLoadMeetFail() {
        let alert = UIAlertController(title: "Meet Load Failed", message: "Could not load meets.  Try to reconnect.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func searchButtonPressed(sender: UIButton) {
    }

    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return queriedMeets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchMeetCell", forIndexPath: indexPath)
        let meet = queriedMeets[indexPath.row]
        cell.textLabel!.text = meet.name
        var location = meet.country
        if let state = meet.state {
            location += ", \(state)"
        }
        location += ", \(meet.city)"
        cell.detailTextLabel!.text = location
        // Configure the cell...
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected")
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
