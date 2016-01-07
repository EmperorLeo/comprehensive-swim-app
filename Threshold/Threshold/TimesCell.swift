//
//  TimesCell.swift
//  Threshold
//
//  Created by Leo Feldman on 1/6/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class TimesCell: UICollectionViewCell {
    
    var time: Double?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
                
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    func setTime(time: Time) {
        self.time = Double(time.time)
        self.backgroundColor = time.timeColor
        
        let label = UILabel(frame: CGRectMake(0,0, self.frame.width, self.frame.height))

        var timeString = makeTimeString(Double(time.time))
        if let finalsTime = time.finalsTime {
            timeString += "P \(makeTimeString(Double(finalsTime)))F"
        }
        label.text = timeString

        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        let colorSuccess = backgroundColor!.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        //this will not work for grey, think of a better way if possible
        if(colorSuccess) {
            label.textColor = UIColor(red: 1 - red, green: 1 - green, blue: 1 - blue, alpha: 1.0)
        }
        else {
            label.textColor = UIColor.blackColor()
        }
        
        label.textAlignment = .Center
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        self.addSubview(label)
    }
    
    override func prepareForReuse() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        self.backgroundColor = UIColor.whiteColor()
    }
    
    override var selected: Bool {
        get {
            return super.selected
        }
        set {
            if newValue {
                super.selected = true
                self.backgroundColor = UIColor(CGColor: CGColorCreateCopyWithAlpha(self.backgroundColor!.CGColor, 0.8)!)
            } else if !newValue {
                super.selected = true
                self.backgroundColor = UIColor(CGColor: CGColorCreateCopyWithAlpha(self.backgroundColor!.CGColor, 1.0)!)
            }
        }
    }
    
    private func makeTimeString(time: Double) -> String {
        
        let roundedTime = Int(time)
        let minutes = String(roundedTime / 60)
        var seconds = String(roundedTime % 60)
        var millis = String(Int((time - Double(roundedTime)) * 100))
        
        if(seconds.characters.count == 1) {
            seconds = "0" + seconds
        }
        if(millis.characters.count == 1) {
            millis = "0" + millis
        }
        
        
        return "\(minutes):\(seconds).\(millis)"

        
    }
    
    
}
