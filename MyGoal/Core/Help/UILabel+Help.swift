//
//  UILabel+Help.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 1/27/17.
//  Copyright © 2017 OnePlanetOps. All rights reserved.
//

import UIKit

extension UILabel
{
    func setAtr(interval aInterval : CGFloat) -> Void
    {
        if (self.text == nil)
        {
            return
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = aInterval
        let attributedString = NSMutableAttributedString(string: self.text!)
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
        self.textAlignment = NSTextAlignment.center
    }
}
