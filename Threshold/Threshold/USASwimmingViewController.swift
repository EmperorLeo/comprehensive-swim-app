//
//  USASwimmingViewController.swift
//  Threshold
//
//  Created by Leo Feldman on 1/30/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class USASwimmingViewController: UIViewController, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var peopleTableView: UITableView!
    @IBOutlet weak var loadTimesButton: UIButton!
    var eventBuffer: [(String, String, String, String, String, String, String, String, String, String)] = []
    var peopleBuffer: [(String, String, String, Int)] = []
    var dataGridPagerPage = 0
    var eventGridPagerPage = 0
    let dateFormatter = NSDateFormatter()
    
    var progressFrame: UIView?
    var progressLabel: UILabel?
    var progress: UIActivityIndicatorView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ThresholdColor.greenColor
        self.loadTimesButton.backgroundColor = ThresholdColor.blueColor
        self.loadTimesButton.layer.borderColor = ThresholdColor.bredColor.CGColor
        self.loadTimesButton.layer.borderWidth = 1
        self.loadTimesButton.layer.cornerRadius = 5.0
        self.loadTimesButton.layer.shadowColor = ThresholdColor.goldColor.CGColor
        self.loadTimesButton.layer.shadowOffset = CGSizeZero
        self.loadTimesButton.layer.shadowRadius = 5.0
        self.loadTimesButton.titleLabel?.shadowOffset = CGSizeZero
        self.loadTimesButton.titleLabel?.shadowColor = ThresholdColor.goldColor
        self.loadTimesButton.setTitleColor(ThresholdColor.bredColor, forState: .Highlighted)
        
        webView.delegate = self
        peopleTableView.delegate = self
        peopleTableView.dataSource = self
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        dateFormatter.dateFormat = "M/d/yyyy"
        
        setUpProgressViews()
        
        let request = NSURLRequest(URL: NSURL(string: "http://www.usaswimming.org/DesktopDefault.aspx?TabId=1470&Alias=Rainbow&Lang=en-US")!)
        webView.loadRequest(request)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loadTimesIntoDatabase(sender: UIButton) {
        
        
        for (row, x) in eventBuffer.enumerate() {
            
//            if eventsTableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0))?.accessoryType != .Checkmark {
//                continue
//            }
            
            let split = x.0.split(" ")
            var event = Models().getEvent(StandardKeyConversion.getStrokeFromAbbrev(split[1]), measurement: x.1,distance: Int(split[0])!)
            if event == nil {
                event = Models().addEvent(StandardKeyConversion.getStrokeFromAbbrev(split[1]), distance: Int(split[0])!, measurement: x.1)
            }
            
            let time = Models().getTimeWithDate(dateFormatter.dateFromString(x.9)!, event: event)
            if let time = time {
                if Double(time.time) > x.4.getSwimTime() {
                    Models().removeObject(time.objectID)
                    Models().addTime(event!, time: x.4.getSwimTime()!, finalsTime: nil, date: dateFormatter.dateFromString(x.9)!, meetName: x.7, clubName: x.8, notes: nil)
                }
            }
            else {
                print(x.9)
                Models().addTime(event!, time: x.4.getSwimTime()!, finalsTime: nil, date: dateFormatter.dateFromString(x.9)!, meetName: x.7, clubName: x.8, notes: nil)
            }
            
            
            
            
        }
        self.navigationController?.popToRootViewControllerAnimated(true)
        
        
    }
    
    func setUpProgressViews() {
        progressFrame = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        self.view.addSubview(progressFrame!)
        progressFrame!.backgroundColor = ThresholdColor.blueColor
        progressFrame!.becomeFirstResponder()
        progressFrame!.center = self.view.center
        progressFrame!.layer.cornerRadius = 10
        progressFrame!.layer.borderColor = UIColor.grayColor().CGColor
        progressFrame!.layer.borderWidth = 1
        progressFrame!.layer.shadowColor = UIColor.blackColor().CGColor
        progressFrame!.layer.shadowOffset = CGSizeZero
        progressFrame!.layer.shadowOpacity = 0.5
        progressFrame!.layer.shadowRadius = 5
        
        let progressStack = UIStackView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//        let progressStack = UIStackView()
        progressStack.axis = .Vertical
        progressStack.alignment = .Center
        progressStack.distribution = .FillEqually
        progressStack.spacing = 5
        progressFrame!.addSubview(progressStack)
        
        progressLabel = UILabel()
        let labelConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:[progressLabel(<=180)]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["progressLabel": progressLabel!])
        progressLabel?.addConstraints(labelConstraint)
        progressLabel!.lineBreakMode = .ByWordWrapping
        progressLabel!.numberOfLines = 0
        progressLabel!.textAlignment = .Center
        progressLabel!.text = "Waiting for USASwimming connection..."
        
        progress = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        progress!.color = UIColor.blackColor()
        
        progressStack.addArrangedSubview(progressLabel!)
        progressStack.addArrangedSubview(progress!)
        progressLabel!.sizeToFit()
        
        
        
        progress!.startAnimating()

    }
    
    func handleResults() {
        
        
        let athleteName = webView.stringByEvaluatingJavaScriptFromString("document.getElementById('ctl63_lblAthleteName').innerHTML")
        let athleteClub = webView.stringByEvaluatingJavaScriptFromString("document.getElementById('ctl63_lblAthleteClub').innerHTML")
        self.navigationItem.title = athleteName! + " " + athleteClub!
        
        
        progressLabel?.text = "Parsing results..."
        
        let numPageScript = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('GridPager')[0].getElementsByTagName('td')[0].getElementsByTagName('a').length")
        
        if !numPageScript!.isEmpty {
            let totalPages = Int(numPageScript!)! + 1
            waitForTimeResultsPageTurn(totalPages, pageNum: 1)
        }
        else {
            self.displaySearchError("There are no results for this swimmer.")
            self.progress!.stopAnimating()
            self.progressFrame!.removeFromSuperview()
        }
        

        
    }
    
    func waitForTimeResultsPageTurn(totalPages: Int, pageNum: Int) {
        let curPage = Int(webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('GridPager')[0].getElementsByTagName('td')[0].getElementsByTagName('span')[0].innerHTML")!)!
        if curPage == pageNum {
            self.getEventsInHtml()
            if curPage != totalPages {
                let javascriptToExecute = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('GridPager')[0].getElementsByTagName('td')[0].getElementsByTagName('a')[\(curPage - 1)].getAttribute('href')")!.split("javascript:")[1]
                webView.stringByEvaluatingJavaScriptFromString(javascriptToExecute)
            }
        }
        
        if curPage != totalPages {
            
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.1) * Int64(NSEC_PER_SEC))
            
            dispatch_after(time, dispatch_get_main_queue()) {
                
                if curPage == pageNum {
                    self.waitForTimeResultsPageTurn(totalPages, pageNum: pageNum + 1)
                }
                else {
                    self.waitForTimeResultsPageTurn(totalPages, pageNum: pageNum)
                }
                
            }

            
        }
        else {
            self.eventBuffer.sortInPlace { (left, right) -> Bool in
                
                if left.1 == right.1 {
                    let spLeft = left.0.split(" ")
                    let spRight = right.0.split(" ")
                    if spLeft[1] == spRight[1] {
                        return spLeft[0] < spRight[0]
                    }
                    else {
                        return spLeft[1] < spRight[1]
                    }
                    
                    
                }
                else {
                    return left.1 < right.1
                }
                
            }
            self.eventsTableView.hidden = false
            self.eventsTableView.reloadData()
            self.loadTimesButton.hidden = false
            self.progress!.stopAnimating()
            self.progressFrame!.removeFromSuperview()

        }
        
        
    }
    
    func getEventsInHtml() {
        var i = 0
        while let eventsRegular = trimToNull(webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridItemStyle')[\(i)].innerHTML")) {
            
            parseEventHtml(eventsRegular)
            i++
        }
        
        i = 0
        while let eventsAlternating = trimToNull(webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridAlternatingItemStyle')[\(i)].innerHTML")) {
            
            parseEventHtml(eventsAlternating)
            i++
        }
        
        
    }
    
    
    func parseEventHtml(html: String) {
//        print(html)
        
        let split = html.split("(<td>|<\\/td>)")
        
        let event = split[1]
        let measurement = split[3]
        let age = split[5]
        let time = split[7]
        let altTime = split[9]
        let powerPoints = split[11]
        let timeStandard = split[13]
        let meetName = split[15]
        let club = split[19]
        let date = split[21]
        
        eventBuffer.append((event, measurement, age, time, altTime, powerPoints, timeStandard, meetName, club, date))
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let lastName = defaults.objectForKey("lastName") as? String
        let firstName = defaults.objectForKey("firstName") as? String
        
        if (trimToNull(lastName) == nil) || (trimToNull(firstName) == nil) {
            displaySearchError("Please provide both a first and last name in the demographics section.")
            progress?.stopAnimating()
            progressFrame?.removeFromSuperview()
            return
        }
        
        let javascript = "document.getElementById('ctl63_txtSearchLastName').value='\(defaults.objectForKey("lastName") as! String)';\n" + "document.getElementById('ctl63_txtSearchFirstName').value='\(defaults.objectForKey("firstName") as! String)';\n" + "document.getElementById('ctl63_radRange').checked=true;\n" + "document.getElementById('ctl00_ctl63_dtStartDate_radTheDate_dateInput').focus();\n" + "document.getElementById('ctl00_ctl63_dtStartDate_radTheDate_dateInput').value='1/1/2000';\n" + "document.getElementById('ctl00_ctl63_dtEndDate_radTheDate_dateInput').focus();\n" + "document.getElementById('ctl00_ctl63_dtEndDate_radTheDate_dateInput').value='\(dateFormatter.stringFromDate(NSDate()))';\n" + "document.getElementById('ctl00_ctl63_dtEndDate_radTheDate_dateInput').blur();\n" + ""
        
        
        webView.stringByEvaluatingJavaScriptFromString(javascript)
        
        let searchButtonScript = webView.stringByEvaluatingJavaScriptFromString("document.getElementById('ctl63_btnSearch').getAttribute('href')")
        webView.stringByEvaluatingJavaScriptFromString(searchButtonScript!.split("javascript:")[1])
        
        
        progressLabel?.text = "Loading swimmer data..."
        waitForResults()
        
    }
    
    func waitForResults() {
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.1) * Int64(NSEC_PER_SEC))
        
        
        dispatch_after(time, dispatch_get_main_queue()) {

            let results = self.webView.stringByEvaluatingJavaScriptFromString("document.getElementById('ctl63_dgSearchResults').innerHTML")
            let selectFromPeopleResults = self.webView.stringByEvaluatingJavaScriptFromString("document.getElementById('ctl63_dgPersonSearchResults').innerHTML")

            if results!.isEmpty && selectFromPeopleResults!.isEmpty {
                self.waitForResults() //recursive call again
            }
            
            else {
                
                if results!.isEmpty {
                    self.progress?.stopAnimating()
                    self.progressFrame?.hidden = true
                    self.parsePersonSearchResults()
                }
                
                else {
                    self.handleResults()
                }
                
                
            }
            
            
            
        }
    }
    
    func waitForPageTurn() {
        
        
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.1) * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {

            let pageNum =         Int(self.webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridPagerStyle')[0].getElementsByTagName('td')[0].getElementsByTagName('span')[0].innerHTML")!)
            if let pageNum = pageNum {
                
                if self.dataGridPagerPage + 2 == pageNum {
                    self.dataGridPagerPage++
                    self.parsePersonSearchResults()
                }
                else {
                    self.waitForPageTurn() //recursive call to wait again
                }
                
            }

            
        }
        
        
    }
    
    func waitForSpecificPageTurn(script: String, toPage: Int) {
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.1) * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            
            let curPage = Int(self.webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridPagerStyle')[0].getElementsByTagName('td')[0].getElementsByTagName('span')[0].innerHTML")!)!
            
            print("\(toPage) \(curPage)")
            if toPage + 1 == curPage {
                
                self.webView.stringByEvaluatingJavaScriptFromString(script)
                self.peopleTableView?.hidden = true

            }
            
            else {
                self.waitForSpecificPageTurn(script, toPage: toPage)
            }
            
        }

        
    }
    
    func parsePersonSearchResults() {
        
        var i = 0
        while let peopleReg = trimToNull(webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridItemStyle')[\(i)].innerHTML")) {
            
            
            let lastName = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridItemStyle')[\(i)].getElementsByTagName('td')[0].innerHTML")!
            let firstName = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridItemStyle')[\(i)].getElementsByTagName('td')[1].innerHTML")!
            let middleInit = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridItemStyle')[\(i)].getElementsByTagName('td')[2].innerHTML")!
            let clubName = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridItemStyle')[\(i)].getElementsByTagName('td')[3].getElementsByTagName('span')[0].innerHTML")!
            let javascript = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridItemStyle')[\(i)].getElementsByTagName('td')[4].getElementsByTagName('a')[0].getAttribute('href')")!.split("javascript:")[1]
//            print(lastName)
//            print(firstName)
//            print(middleInit)
//            print(clubName)
//            print(javascript)
            
            if middleInit.containsString("&nbsp;") {
                self.peopleBuffer.append(("\(firstName) \(lastName)", clubName, javascript, dataGridPagerPage))
            }
            else {
                self.peopleBuffer.append(("\(firstName) \(middleInit) \(lastName)", clubName, javascript, dataGridPagerPage))
            }
            
            i++
        }
        
        i = 0
        while let peopleAlt = trimToNull(webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridAlternatingItemStyle')[\(i)].innerHTML")) {
            
            let lastName = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridAlternatingItemStyle')[\(i)].getElementsByTagName('td')[0].innerHTML")!
            let firstName = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridAlternatingItemStyle')[\(i)].getElementsByTagName('td')[1].innerHTML")!
            let middleInit = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridAlternatingItemStyle')[\(i)].getElementsByTagName('td')[2].innerHTML")!
            let clubName = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridAlternatingItemStyle')[\(i)].getElementsByTagName('td')[3].getElementsByTagName('span')[0].innerHTML")!
            let javascript = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridAlternatingItemStyle')[\(i)].getElementsByTagName('td')[4].getElementsByTagName('a')[0].getAttribute('href')")!.split("javascript:")[1]
//            print(lastName)
//            print(firstName)
//            print(middleInit)
//            print(clubName)
//            print(javascript)
            
            if middleInit.containsString("&nbsp;") {
                self.peopleBuffer.append(("\(firstName) \(lastName)", clubName, javascript, dataGridPagerPage))
            }
            else {
                self.peopleBuffer.append(("\(firstName) \(middleInit) \(lastName)", clubName, javascript, dataGridPagerPage))
            }
            
            i++
        }
        
        if peopleBuffer.count != 0 {
            self.peopleTableView.hidden = false
            self.peopleTableView.reloadData()
        }
        else {
            let defaults = NSUserDefaults.standardUserDefaults()
            displaySearchError("No person with the name \(defaults.objectForKey("firstName") as! String) \(defaults.objectForKey("lastName") as! String) found.")
        }
        

        
        
    }
    
    func displaySearchError(error: String) {
        
        let alert = UIAlertController(title: "Error loading swimmer", message: error, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default) { action in
            
            self.peopleBuffer.removeAll()
            self.eventBuffer.removeAll()
            self.dataGridPagerPage = 0
            self.viewDidLoad()

            
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { action in
            
            
            self.navigationController?.popToRootViewControllerAnimated(true)
            
            
        })

        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func parsePersonHtml(html: String) {
        print(html)
    }
    
    func waitForHandleResults() {
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.1) * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {

            let results = self.webView.stringByEvaluatingJavaScriptFromString("document.getElementById('ctl63_dgSearchResults').innerHTML")!
            let possibleError = self.webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('NormalError')[1].innerHTML")!
            
            if possibleError == "The person you selected has no USA-S ID" {
                self.displaySearchError("The person you selected has no USA-S ID")
            }
            
            else {
                
                if results.isEmpty {
                    self.waitForHandleResults() //recursive call, run again
                }
                else {
                    self.handleResults()
                }
                
            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == peopleTableView {
            if peopleBuffer.count == 0 {
                return 0
            }
            let numPages = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridPagerStyle')[0].getElementsByTagName('td')[0].getElementsByTagName('a').length")!
            
            if numPages.isEmpty {
                return 0
            }
            
            if dataGridPagerPage + 1 > Int(numPages) {
                return peopleBuffer.count
            }
            return peopleBuffer.count + 1
        }
        else if tableView == eventsTableView {
            return eventBuffer.count
        }
        else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == peopleTableView {
            if indexPath.row < peopleBuffer.count {
                
                
                let curPage = Int(webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridPagerStyle')[0].getElementsByTagName('td')[0].getElementsByTagName('span')[0].innerHTML")!)!
                if peopleBuffer[indexPath.row].3 + 1 != curPage {
                    print("switching pages")
                    let switchPageScript = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridPagerStyle')[0].getElementsByTagName('td')[0].getElementsByTagName('a')[\(peopleBuffer[indexPath.row].3)].getAttribute('href')")!.split("javascript:")[1]
                    webView.stringByEvaluatingJavaScriptFromString(switchPageScript)
                    waitForSpecificPageTurn(peopleBuffer[indexPath.row].2, toPage: peopleBuffer[indexPath.row].3)
                    
                }
                else {
                    webView.stringByEvaluatingJavaScriptFromString(peopleBuffer[indexPath.row].2)
                    peopleTableView?.hidden = true
                }
                progressFrame?.hidden = false
                progress?.startAnimating()
                progressLabel?.text = "Waiting for results..."
                waitForHandleResults()
            }
            else { //should mean that loadMore was clicked...
            
                let href = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridPagerStyle')[0].getElementsByTagName('td')[0].getElementsByTagName('a')[\(dataGridPagerPage)].getAttribute('href')")
                if href!.containsString("javascript:") {
                    webView.stringByEvaluatingJavaScriptFromString(href!.split("javascript:")[1])
                    
                    self.waitForPageTurn()
                }
                
                
            }
        }
//        else if tableView == eventsTableView {
//            if tableView.cellForRowAtIndexPath(indexPath)?.accessoryType == .Checkmark {
//                tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
//            }
//            else {
//                tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
//            }
//        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == peopleTableView {
            let cell: UITableViewCell?
            if indexPath.row < peopleBuffer.count {
                cell = tableView.dequeueReusableCellWithIdentifier("peopleTableViewCell")
                let person = peopleBuffer[indexPath.row]
                cell?.textLabel?.text = person.0
                cell?.detailTextLabel?.text = person.1
            }
            else {
                cell = tableView.dequeueReusableCellWithIdentifier("loadMoreCell")
                cell?.textLabel?.text = "Load more..."
            }
            return cell!
        }
        else if tableView == eventsTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier("eventsTableViewCell")
            let event = eventBuffer[indexPath.row]
            (cell?.viewWithTag(0) as! UILabel).text = "\(event.0) \(event.1)"
            (cell?.viewWithTag(1) as! UILabel).text = "Power Points: \(event.5)"
            (cell?.viewWithTag(2) as! UILabel).text = "\(event.3)"
            (cell?.viewWithTag(3) as! UILabel).text = "Standard: \(event.6)"
            (cell?.viewWithTag(4) as! UILabel).text = event.8
            (cell?.viewWithTag(5) as! UILabel).text = event.7
            (cell?.viewWithTag(6) as! UILabel).text = event.9
            (cell?.viewWithTag(7) as! UILabel).text = "Age when swum: \(event.2)"
            cell?.contentView.layer.borderWidth = 1
            cell?.contentView.layer.borderColor = UIColor.blackColor().CGColor

            if indexPath.row % 2 == 0 {
                cell?.contentView.layer.backgroundColor = tableCellColor.CGColor
            }
            else {
                cell?.contentView.layer.backgroundColor = altTableCellColor.CGColor
            }
            
//            cell?.textLabel?.text = "\(event.0) \(event.1)"
//            cell?.detailTextLabel?.text = "\(event.3) - \(event.7) - \(event.8)"
//            cell?.accessoryType = .Checkmark
            return cell!
        }
        else {
            return UITableViewCell()
        }
        
    }
    
    
    
    
//    func processEvents() {
//        
//        bufferFilled.wait()
//        
//    }
    
    

}
