//
//  DigitalClock.swift
//  Swim Friend iOS
//
//  Created by Leo Feldman on 12/17/15.
//  Copyright © 2015 Leo and Ray. All rights reserved.
//

import UIKit

class DigitalClock: UIStackView {

    var hoursLabel: UILabel = UILabel()
    var separator1: UILabel = UILabel()
    var minutesLabel: UILabel = UILabel()
    var separator2: UILabel = UILabel()
    var secondsLabel: UILabel = UILabel()
    var internalTime: Int
    
    required override init(frame: CGRect) {
        internalTime = 0
        super.init(frame: frame)
        initInternal()
    }

    required init?(coder aDecoder: NSCoder) {
        internalTime = 0
        super.init(coder: aDecoder)
        initInternal()
    }
    
    func initInternal() {
        hoursLabel.text = "0"
        separator1.text = ":"
        minutesLabel.text = "00"
        separator2.text = ":"
        secondsLabel.text = "00"
        
        hoursLabel.sizeToFit();separator1.sizeToFit();minutesLabel.sizeToFit();separator2.sizeToFit();secondsLabel.sizeToFit()
        
//        let labelFrame = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 100, height: 100))
        let labelFont = UIFont(name: "LetsgoDigital-Regular", size: 72.0)
        
//        hoursLabel.frame = labelFrame;separator1.frame = labelFrame;minutesLabel.frame = labelFrame;separator2.frame = labelFrame;secondsLabel.frame = labelFrame
        hoursLabel.font = labelFont;separator1.font = labelFont;minutesLabel.font = labelFont;separator2.font = labelFont;secondsLabel.font = labelFont

        
        self.axis = UILayoutConstraintAxis.Horizontal
        self.alignment = UIStackViewAlignment.Fill
        self.distribution = UIStackViewDistribution.EqualSpacing
        self.spacing = 10
        self.addArrangedSubview(hoursLabel)
        self.addArrangedSubview(separator1)
        self.addArrangedSubview(minutesLabel)
        self.addArrangedSubview(separator2)
        self.addArrangedSubview(secondsLabel)

    }
    
    func setTimer(var seconds: Int) {
        internalTime = seconds
        let hours = seconds / 3600
        seconds -= (hours * 3600)
        let minutes = seconds / 60
        seconds -= (minutes * 60)
        hoursLabel.text = String(hours)
        if(String(minutes).characters.count == 1) {
            minutesLabel.text = "0" + String(minutes)
        }
        else {
            minutesLabel.text = String(minutes)
        }
        
        if(String(seconds).characters.count == 1) {
            secondsLabel.text = "0" + String(seconds)
        }
        else {
            secondsLabel.text = String(seconds)
        }
    }
    
    func decrement() {
        setTimer(internalTime - 1)
    }

    
    
}
