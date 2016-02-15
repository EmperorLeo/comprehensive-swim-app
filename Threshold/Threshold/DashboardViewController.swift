//
//  DashboardViewController.swift
//  Threshold
//
//  Created by Leo Feldman on 1/30/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit
import Charts
import FBSDKShareKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var timeLengthSegment: UISegmentedControl!
    @IBOutlet weak var graph: LineChartView!
    @IBOutlet weak var fbShareButton: FBSDKShareButton!
    
    
    var events = [Event]()
    var selectedIndex = 0
    let dateFormat = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThresholdColor.greenColor
        themeUIViews([timeLengthSegment, graph])
        events = Models().getEvents().sort()
        chartSettings()
        dateFormat.dateFormat = "MM-dd-YYYY"
        if !events.isEmpty {
            setUpChart(events[selectedIndex]);
        } else {
            self.navigationItem.title = "Threshold"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func chartSettings() {
        graph.descriptionText = ""
        graph.leftAxis.enabled = true
        graph.leftAxis.valueFormatter = TimesFormatter()
        graph.xAxis.enabled = true
        graph.xAxis.labelPosition = .Bottom
        graph.legend.enabled = false
        graph.noDataText = "Add times to this event in order to see a graph!"
        graph.leftAxis.startAtZeroEnabled = false
        graph.rightAxis.enabled = false
        graph.pinchZoomEnabled = false
        graph.scaleXEnabled = false
        graph.scaleYEnabled = false
        graph.gridBackgroundColor = ThresholdColor.blueColor
        graph.leftAxis.gridColor = ThresholdColor.goldColor
        graph.xAxis.gridColor = ThresholdColor.goldColor

    }
    
    func shareSetUp() {
        let shareContent = FBSDKShareLinkContent()
        
        let event = events[selectedIndex]
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory: NSString = paths[0]
        let localFilePath: NSString = documentsDirectory.stringByAppendingPathComponent("\(Int(event.distance))\(event.stroke)\(event.measurement)-\(timeLengthSegment.selectedSegmentIndex).png")

//        shareContent.contentURL = NSURL(string: "http://www.apple.com")
        shareContent.imageURL = NSURL(string: localFilePath as String)!
        shareContent.contentTitle = event.toString()
        shareContent.contentDescription = "Progress for this event over \(timeLengthSegment.titleForSegmentAtIndex(timeLengthSegment.selectedSegmentIndex))!"
        fbShareButton.shareContent = shareContent

    }
    
    func setUpChart(event: Event) {
        
        self.navigationItem.title = event.toString()
        
        let times = Models().getTimes(event).sort()
        if times.count == 0 {
            graph.clear()
            return
        }
        
//        graph.animate(yAxisDuration: 1.25, easingOption: ChartEasingOption.EaseOutExpo)
        
        var numDays = 0
        
        if timeLengthSegment.selectedSegmentIndex == 0 {
            numDays = 90
        } else if timeLengthSegment.selectedSegmentIndex == 1 {
            numDays = 180
        } else if timeLengthSegment.selectedSegmentIndex == 2 {
            numDays = 365
        } else if timeLengthSegment.selectedSegmentIndex == 3 {
            numDays = 730
        } else if timeLengthSegment.selectedSegmentIndex == 4 {
            if !times.isEmpty {
                numDays = Int(abs(times[0].meetDate.date.timeIntervalSinceDate(NSDate()) / (60*60*24))) + 1
            }
        }
        let numSeconds = Double(numDays * 24 * 60 * 60)
        
        var dateValues: [String] = []
        var timeValues: [ChartDataEntry] = []
        var colorDict = [Int: UIColor]()
        var colors = [UIColor]()
        
        let today = Double(NSDate().timeIntervalSince1970)
        
//        var maxValue: Double?
        
        for time in times {
            let timeDouble = Double(time.time)
            let date = time.meetDate.date.timeIntervalSince1970
            let secondsBack = today - Double(date)
            if (secondsBack) > numSeconds {
                
                continue
//                if maxValue == nil || maxValue < timeDouble {
//                    maxValue = timeDouble
//                }
                
                
//                continue //too far back to be a data point
            }
            
            let xIndex: Int = numDays - 1 - (Int(secondsBack) / (24*60*60))
            timeValues.append(ChartDataEntry(value: timeDouble, xIndex: xIndex))
            colorDict[xIndex] = time.timeColor
            colors.append(time.timeColor)
        }
        
        for index in 1...numDays {
            let daysAgo = numDays - index
            let day = NSDate(timeIntervalSince1970: today - Double(daysAgo * 24 * 60 * 60))
            dateValues.append(dateFormat.stringFromDate(day))
        }
        
//        if times.count > 1 {
//            graph.leftAxis.axisMaximum = maxValue!
//        }
        
        let dataSet = LineChartDataSet(yVals: timeValues, label: "Times")
        dataSet.colors = [dataLineBlue]
        dataSet.setCircleColor(dataPointBlue)
        dataSet.fillColor = UIColor.greenColor()
        dataSet.circleRadius = 4
        dataSet.drawValuesEnabled = false
        dataSet.lineWidth = 3
        //        dataSet.fillAlpha = 1.0
//        dataSet.drawCirclesEnabled = true
//        dataSet.drawValuesEnabled = true
        let data = LineChartData(xVals: dateValues, dataSet: dataSet)
        
        graph.data = data
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory: NSString = paths[0]
        let localFilePath: NSString = documentsDirectory.stringByAppendingPathComponent("\(Int(event.distance))\(event.stroke)\(event.measurement)-\(timeLengthSegment.selectedSegmentIndex).png")
//        print(localFilePath as String)
        graph.saveToPath(localFilePath as String, format: .PNG, compressionQuality: 1.0)
//        print(saved)
//        graph.leftAxis.customAxisMin = minTime!
//        graph.leftAxis.customAxisMax = maxTime!
        
        shareSetUp()
        
    }
    
    @IBAction func graphDurationChanged(sender: UISegmentedControl) {
        
    }

    @IBAction func goRightClicked(sender: AnyObject) {
        if events.isEmpty {
            return
        }
        
        selectedIndex++
        if selectedIndex > (events.count - 1) {
            selectedIndex = 0
        }
        setUpChart(events[selectedIndex])
        
    }
    
    @IBAction func goLeftClicked(sender: AnyObject) {
        if events.isEmpty {
            return
        }        
        
        selectedIndex--
        if selectedIndex < 0 {
            selectedIndex = events.count - 1
        }
        setUpChart(events[selectedIndex])
    }
    
    @IBAction func menuClicked(sender: AnyObject) {
        
    }
    
    @IBAction func timeLengthChanged(sender: UISegmentedControl) {
        if !events.isEmpty {
            setUpChart(events[selectedIndex])
        }
        
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if(self == viewController) {
            self.viewDidLoad()
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
