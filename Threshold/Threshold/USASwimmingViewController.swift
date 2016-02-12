//
//  USASwimmingViewController.swift
//  Threshold
//
//  Created by Leo Feldman on 1/30/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class USASwimmingViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
//    let bufferFilled = NSCondition()
//    
//    
//    var eventBuffer: [(String, String, String, String, String, String, String, String, String)] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        
        let request = NSURLRequest(URL: NSURL(string: "http://www.usaswimming.org/DesktopDefault.aspx?TabId=1470&Alias=Rainbow&Lang=en-US")!)
//        let onLoadThread = NSThread(target: self, selector: "loadValuesIntoWebView", object: nil)
//        onLoadThread.start()
        webView.loadRequest(request)
//        while !webView.loading {
//            
//        }
//        requestLoadStart.signal()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadValuesIntoWebView() {
        
//        requestLoadStart.wait()
//        
//        while webView.loading {
//            //wait, just keep spinning
//            print("LOL")
//        }
//        
//        print("goodbye")
        
//        print(webView.stringByEvaluatingJavaScriptFromString("document.body.innerHTML"))
        

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func loadHtmlPressed(sender: UIButton) {
        
        
            handleResults()
        
        
    }
    
    func handleResults() {
        
        let progressFrame = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        self.view.addSubview(progressFrame)
        progressFrame.backgroundColor = UIColor.whiteColor()
        progressFrame.becomeFirstResponder()
        progressFrame.center = self.view.center
        
        let progressStack = UIStackView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        progressStack.axis = .Vertical
        progressStack.alignment = .Center
        progressStack.distribution = .FillEqually
        progressStack.spacing = 5
        progressFrame.addSubview(progressStack)
        let topConstraint = NSLayoutConstraint(item: progressStack, attribute: .Top, relatedBy: .Equal, toItem: progressFrame, attribute: .Top, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: progressStack, attribute: NSLayoutAttribute.Left, relatedBy: .Equal, toItem: progressFrame, attribute: .Left, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: progressStack, attribute: .Right, relatedBy: .Equal, toItem: progressFrame, attribute: .Right, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: progressStack, attribute: .Bottom, relatedBy: .Equal, toItem: progressFrame, attribute: .Bottom, multiplier: 1, constant: 0)
        progressFrame.addConstraints([topConstraint, leftConstraint, rightConstraint, bottomConstraint])
        
        let progressLabel = UILabel()
        progressLabel.text = "Processing..."
        
        let progress = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        //        progress.center = progressFrame.convertPoint(progressFrame.center, fromCoordinateSpace: self.view)
        progress.color = UIColor.blackColor()
        
        progressStack.addArrangedSubview(progressLabel)
        progressStack.addArrangedSubview(progress)
        progressLabel.sizeToFit()
        
        
        
        progress.startAnimating()
        
        var javascriptToExecute: [String] = []
        if let pagesHtml = trimToNull(webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('GridPager')[0].innerHTML")) {
            
            let javascript = "javascript:"
            let indexes = pagesHtml.indexesOfString(javascript)
            
            for index in indexes {
                
                let newIndex = index + javascript.characters.count
                let funcString = pagesHtml.substringFromIndex(pagesHtml.startIndex.advancedBy(newIndex))
                let endIndex = funcString.characters.indexOf(")")
                let finalJavascriptString = funcString.substringToIndex(endIndex!.advancedBy(1))
                javascriptToExecute.append(finalJavascriptString)
                
            }
            
        }
        
        var delay = 1.0
        for num in 0...javascriptToExecute.count {
            
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(delay) * Int64(NSEC_PER_SEC))
            
            dispatch_after(time, dispatch_get_main_queue()) {
                self.getEventsInHtml()
                //                print("html print")
                
                if num != javascriptToExecute.count {
                    self.webView.stringByEvaluatingJavaScriptFromString(javascriptToExecute[num])
                    //                    print(String(num) + " " + javascriptToExecute[num])
                    
                }
                else {
                    progress.stopAnimating()
                    progressFrame.removeFromSuperview()
                    
                }
                
            }
            
            delay += 1.0
            
            
            
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
        let date = split[21]
        
        print(event)
        print(measurement)
        print(age)
        print(time)
        print(altTime)
        print(powerPoints)
        print(timeStandard)
        print(meetName)
        print(date)
        
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        print(webView.loading)
        let defaults = NSUserDefaults.standardUserDefaults()
        let html = webView.stringByEvaluatingJavaScriptFromString("document.body.innerHTML")
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let javascript = "document.getElementById('ctl63_txtSearchLastName').value='\(defaults.objectForKey("lastName") as! String)';\n" + "document.getElementById('ctl63_txtSearchFirstName').value='\(defaults.objectForKey("firstName") as! String)';\n" + "document.getElementById('ctl63_radRange').checked=true;\n" + "document.getElementById('ctl00_ctl63_dtStartDate_radTheDate_dateInput').focus();\n" + "document.getElementById('ctl00_ctl63_dtStartDate_radTheDate_dateInput').value='1/1/2000';\n" + "document.getElementById('ctl00_ctl63_dtEndDate_radTheDate_dateInput').focus();\n" + "document.getElementById('ctl00_ctl63_dtEndDate_radTheDate_dateInput').value='\(dateFormatter.stringFromDate(NSDate()))';\n" + "document.getElementById('ctl00_ctl63_dtEndDate_radTheDate_dateInput').blur();\n" + ""
        
        
        webView.stringByEvaluatingJavaScriptFromString(javascript)
        
        let searchButtonScript = webView.stringByEvaluatingJavaScriptFromString("document.getElementById('ctl63_btnSearch').getAttribute('href')")
        webView.stringByEvaluatingJavaScriptFromString(searchButtonScript!.split("javascript:")[1])
        
        

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
                    self.parsePersonSearchResults()
                }
                
                else {
                    self.handleResults()
                }
                
                
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
            print(lastName)
            print(firstName)
            print(middleInit)
            print(clubName)
            print(javascript)
            
            i++
        }
        
        i = 0
        while let peopleAlt = trimToNull(webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridAlternatingItemStyle')[\(i)].innerHTML")) {
            
            let lastName = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridItemStyle')[\(i)].getElementsByTagName('td')[0].innerHTML")!
            let firstName = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridItemStyle')[\(i)].getElementsByTagName('td')[1].innerHTML")!
            let middleInit = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridItemStyle')[\(i)].getElementsByTagName('td')[2].innerHTML")!
            let clubName = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridItemStyle')[\(i)].getElementsByTagName('td')[3].getElementsByTagName('span')[0].innerHTML")!
            let javascript = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('DataGridItemStyle')[\(i)].getElementsByTagName('td')[4].getElementsByTagName('a')[0].getAttribute('href')")!.split("javascript:")[1]
            print(lastName)
            print(firstName)
            print(middleInit)
            print(clubName)
            print(javascript)
            
            i++
        }

        
        
    }
    
    func parsePersonHtml(html: String) {
        print(html)
    }
    
    
    
//    func processEvents() {
//        
//        bufferFilled.wait()
//        
//    }
    
    

}
