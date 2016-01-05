//
//  EventPicker.swift
//  Threshold
//
//  Created by Leo Feldman on 12/31/15.
//  Copyright © 2015 Leo. All rights reserved.
//

import UIKit

class EventPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let distData = ["50", "100", "200", "400", "500", "800", "1000", "1500", "1650"]
    let strokeData = ["Freestyle", "Backstroke", "Breaststroke", "Butterfly", "Corkscrew", "Doggypaddle"]
    let measurement = ["SCY", "SCM", "LCM"]
    
//    lazy var array = [distData, strokeData, measurement]
    
    
    init() {
        
        super.init(frame: CGRect())
        
        self.delegate = self
        self.dataSource = self

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    //    override init(frame: CGRect) {
    //        super.init(frame: frame)
    //        self.add
    //
    //    }
    //
    //    required init?(coder aDecoder: NSCoder) {
    //        super.init(coder: aDecoder)
    //    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let array = [distData, strokeData, measurement]
        return array[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let array = [distData, strokeData, measurement]
        return array[component][row]
    }
    
    func getSelectedDistance() -> String {
        return distData[self.selectedRowInComponent(0)]
    }
    
    func getSelectedStroke() -> String {
        return strokeData[self.selectedRowInComponent(1)]
    }
    
    func getSelectedMeasurement() -> String {
        return measurement[self.selectedRowInComponent(2)]
    }
    
}
