//
//  TimePicker.swift
//  Threshold
//
//  Created by Leo Feldman on 1/5/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class TimePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    init() {
        
        super.init(frame: CGRect())
        
//        let hourLabel = UILabel(frame: <#T##CGRect#>)
//        let minuteLabel = UILabel(frame: <#T##CGRect#>)
//        let secondLabel = UILabel(frame: <#T##CGRect#>)
        
        self.delegate = self
        self.dataSource = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0) {
            return 60
        } else if(component == 1) {
            return 60
        } else {
            return 100
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title = String(row)
        if(title.characters.count == 1) {
            title = "0" + title
        }
        return title
    }
    
    func setSelectedTime(time: Double) {
        
        let roundedTime = Int(time)
        let minutes = roundedTime / 60
        let seconds = roundedTime % 60
        let millis = Int((time - Double(roundedTime)) * 100)
        
        self.selectRow(minutes, inComponent: 0, animated: false)
        self.selectRow(seconds, inComponent: 1, animated: false)
        self.selectRow(millis, inComponent: 2, animated: false)
        
    }
    
    func setSelectedTimeUsingString(stringTime: String) {
        
        let splitArray = stringTime.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: ".:"))
        
        let minutes = Int(splitArray[0])
        let seconds = Int(splitArray[1])
        let millis = Int(splitArray[2])
        
        self.selectRow(minutes!, inComponent: 0, animated: false)
        self.selectRow(seconds!, inComponent: 1, animated: false)
        self.selectRow(millis!, inComponent: 2, animated: false)
    }
    
    func getSelectedTime() -> Double {
        let minutes = Double(self.selectedRowInComponent(0))
        let seconds = Double(self.selectedRowInComponent(1))
        let hundredths = Double(self.selectedRowInComponent(2))
        
        let totalTime = minutes * 60 + seconds + hundredths * (1/100)
        
        return totalTime
    }
    
    func getSelectedTimeString() -> String {
        let minutes = String(self.selectedRowInComponent(0))
        let seconds = String(self.selectedRowInComponent(1))
        let hundredths = String(self.selectedRowInComponent(2))
        let timesArray = NSMutableArray(arrayLiteral: minutes, seconds, hundredths)
        for(var i=0; i<3;i++) {
            if((timesArray[i] as! String).characters.count == 1) {
                timesArray[i] = "0" + (timesArray[i] as! String)
            }
        }
        
        return "\(timesArray[0]):\(timesArray[1]).\(timesArray[2])"
        
    }
    
}
