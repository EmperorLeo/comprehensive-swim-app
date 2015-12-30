//
//  SideTableViewController.swift
//  Swim Friend OSX
//
//  Created by Leo Feldman on 12/27/15.
//  Copyright © 2015 Leo and Ray. All rights reserved.
//

import Cocoa

class SideTableViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var tableView: NSTableView!
    
    var tableStrings = ["Meet Builder","Swimmer Signup"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.x
        tableView.setDelegate(self)
        tableView.setDataSource(self)
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return tableStrings.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = NSTextField()
        cell.textColor = NSColor.greenColor()
        cell.stringValue = tableStrings[row]
        
        return cell
    }
    
    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if(row == 0) {
            
        } else if(row == 1) {
            
        }
        
        return true
    }
    
}
