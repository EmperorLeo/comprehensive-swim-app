//
//  HeaderCell.swift
//  Threshold
//
//  Created by Leo Feldman on 1/6/16.
//  Copyright © 2016 Leo. All rights reserved.
//

import UIKit

class HeaderCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        self.backgroundColor = UIColor.blackColor()
        let title = UILabel()
        title.text = "Hello"
        title.textColor = UIColor.whiteColor()
        title.textAlignment = .Center
        self.addSubview(title)
        title.sizeToFit()
        title.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
}
