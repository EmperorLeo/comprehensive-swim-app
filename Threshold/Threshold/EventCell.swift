//
//  EventCell.swift
//  Threshold
//
//  Created by Leo Feldman on 1/6/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 149.0/255, green: 165.0/255, blue: 166.0/255, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepareForReuse() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    func setEvent(event: String) {
        let label = UILabel(frame: CGRectMake(0,0,self.frame.width,self.frame.height))
        label.text = event
        label.textAlignment = .Center
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        self.addSubview(label)
    }
    
}
