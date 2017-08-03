//
//  SMLabel.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 12/22/16.
//  Copyright © 2016 OnePlanetOps. All rights reserved.
//

import UIKit

class SMLabel: UILabel
{
    var topT: CGFloat = 0.0
    var leftT: CGFloat = 0.0
    var bottomT: CGFloat = 0.0
    var rightT: CGFloat = 0.0

    override func draw(_ rect: CGRect)
    {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(topT, leftT, bottomT, rightT)))
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect
    {
        var rect: CGRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        
        rect.origin.x -= leftT
        rect.origin.y -= rightT
        rect.size.width += (leftT + rightT)
        rect.size.height += (topT + bottomT)
        
        return rect
    }
}
