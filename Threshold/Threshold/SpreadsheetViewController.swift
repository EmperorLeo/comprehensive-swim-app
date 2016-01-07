//
//  SpreadsheetViewController.swift
//  Threshold
//
//  Created by Leo Feldman on 1/6/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit
import MMSpreadsheetView
import CMPopTipView

class SpreadsheetViewController: UIViewController, MMSpreadsheetViewDelegate, MMSpreadsheetViewDataSource, CMPopTipViewDelegate {

    var spreadsheet: MMSpreadsheetView?
    var events: [Event]?
    var dates: [MeetDate]?
    
    var times: [[Time?]]?
    
    var tipView: CMPopTipView?
    
    let dateFormatter = NSDateFormatter()
    
    var selected: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        events = Models().getEvents().sort()
        dates = Models().getDates().sort()
        
        times = [[Time?]](count: events!.count, repeatedValue: [Time?](count: dates!.count, repeatedValue: nil)) //initialize 2d-array to make access times faster
    
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        self.view.autoresizingMask = UIViewAutoresizing.FlexibleHeight
                
        spreadsheet = MMSpreadsheetView(numberOfHeaderRows: 1, numberOfHeaderColumns: 1, frame: self.view.bounds)
        spreadsheet!.delegate = self
        spreadsheet!.dataSource = self
        spreadsheet!.registerCellClass(HeaderCell.self, forCellWithReuseIdentifier: "HeaderCell")
        spreadsheet!.registerCellClass(EventCell.self, forCellWithReuseIdentifier: "EventCell")
        spreadsheet!.registerCellClass(DateCell.self, forCellWithReuseIdentifier: "DateCell")
        spreadsheet!.registerCellClass(TimesCell.self, forCellWithReuseIdentifier: "TimesCell")
        spreadsheet!.backgroundColor = UIColor.blackColor()
        
        
        
        self.view.addSubview(spreadsheet!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfColumnsInSpreadsheetView(spreadsheetView: MMSpreadsheetView!) -> Int {
        let numCols = dates!.count + 1
        if(numCols == 1) {
            return 2
        }
        return numCols
    }
    
    func numberOfRowsInSpreadsheetView(spreadsheetView: MMSpreadsheetView!) -> Int {
        let numRows = events!.count + 1
        if numRows == 1 {
            return 2
        }
        return numRows
    }
    
    func spreadsheetView(spreadsheetView: MMSpreadsheetView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {

        let row = indexPath.mmSpreadsheetRow()
        let column = indexPath.mmSpreadsheetColumn()
        
        
        if row == 0 && column == 0 {
            let cell = spreadsheetView.dequeueReusableCellWithReuseIdentifier("HeaderCell", forIndexPath: indexPath)
            return cell
        }
        else if row == 0 && column > 0 {
            let cell = spreadsheetView.dequeueReusableCellWithReuseIdentifier("DateCell", forIndexPath: indexPath)
            if(dates!.count == 0) {
                return cell
            }
            
//            let label = UILabel()
//            label.text = dateFormatter.stringFromDate(dates![column - 1].date)
//            
//            cell.addSubview(label)
//            label.sizeToFit()
            
            (cell as! DateCell).setDate(dateFormatter.stringFromDate(dates![column - 1].date))
            
            return cell
        }
        else if row > 0 && column == 0 {
            let cell = spreadsheetView.dequeueReusableCellWithReuseIdentifier("EventCell", forIndexPath: indexPath)
            if(events!.count == 0) {
                return cell
            }
                        
            (cell as! EventCell).setEvent(events![row - 1].toString())
            
            return cell
        }
        else {
            let cell = spreadsheetView.dequeueReusableCellWithReuseIdentifier("TimesCell", forIndexPath: indexPath)
            if(events!.count == 0 || dates!.count == 0) {
                return cell
            }
            let date = dates![column - 1]
            let event = events![row - 1]
            
            for time in date.times!.allObjects as! [Time] {
                if time.event!.objectID == event.objectID {
                    (cell as! TimesCell).setTime(time)
                    times![row - 1][column - 1] = time
                    break
                }
            }
            return cell
        }
    }
    
    func spreadsheetView(spreadsheetView: MMSpreadsheetView!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        let x = indexPath.mmSpreadsheetColumn()
        let y = indexPath.mmSpreadsheetRow()
        
        if(y == 0) {
            return CGSizeMake(100, 100)
        }
        else {
            return CGSizeMake(100, 50)
        }
    }
    
    func spreadsheetView(spreadsheetView: MMSpreadsheetView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {

        if(events!.count == 0 || dates!.count == 0) {
            return
        }
        
        
        if let tipView = self.tipView {
            tipView.dismissAnimated(true)
            self.tipView = nil
            spreadsheet!.deselectItemAtIndexPath(selected, animated: true)
            if(indexPath.mmSpreadsheetColumn() == selected!.mmSpreadsheetColumn() && indexPath.mmSpreadsheetRow() == selected!.mmSpreadsheetRow()) {
                return
            }
            selected = nil
        }
        
        if(indexPath.mmSpreadsheetColumn() == 0 || indexPath.mmSpreadsheetRow() == 0) {
            return
        }
        
        selected = indexPath
        let time = times![indexPath.mmSpreadsheetRow() - 1][indexPath.mmSpreadsheetColumn() - 1]
        if let time = time {
            var title: String = ""
            if let meetName = time.meetName {
                title += meetName
            }
            if let clubName = time.clubName {
                title += " /w \(clubName)"
            }
            
            if(title != "" || (time.notes != nil && time.notes!.characters.count != 0)) {
                tipView = CMPopTipView(title: title, message: time.notes)
                tipView!.delegate = self
                tipView!.backgroundColor = time.timeColor
                tipView!.textColor = UIColor.blackColor()
                let bottomRightCollectionView = spreadsheetView.collectionViewForDataSourceIndexPath(indexPath)
                let newPath = spreadsheetView.dataSourceIndexPathFromCollectionView(bottomRightCollectionView, indexPath: NSIndexPath(forRow: indexPath.mmSpreadsheetColumn() - 2, inSection: indexPath.mmSpreadsheetRow() - 2));
                print(newPath.mmSpreadsheetRow())
                print(newPath.mmSpreadsheetColumn())
                let cell = bottomRightCollectionView.cellForItemAtIndexPath(newPath)
                print("origin=(\(bottomRightCollectionView.bounds.origin.x),\(bottomRightCollectionView.bounds.origin.y)), size=(\(bottomRightCollectionView.bounds.width),\(bottomRightCollectionView.bounds.height))")
                print((cell as! TimesCell).time!)
                
                tipView!.presentPointingAtView(cell, inView: bottomRightCollectionView, animated: true)
                
            }
        }
        
    }
    
    func popTipViewWasDismissedByUser(popTipView: CMPopTipView!) {
        tipView = nil
        spreadsheet!.deselectItemAtIndexPath(selected, animated: true)
        selected = nil
    }
        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
