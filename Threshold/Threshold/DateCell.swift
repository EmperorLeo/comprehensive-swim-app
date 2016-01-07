//
//  DateCell.swift
//  Threshold
//
//  Created by Leo Feldman on 1/6/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class DateCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 210.0/255, green: 215.0/255, blue: 211.0/255, alpha: 1.0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepareForReuse() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    func setDate(date: String) {
        
        let label = UILabel(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
        label.text = date
        label.textAlignment = .Center
        self.addSubview(label)

    }

}
