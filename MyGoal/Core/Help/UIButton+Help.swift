//
//  UIButton+Help.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 4/11/17.
//  Copyright © 2017 Contractors.com. All rights reserved.
//

import UIKit

extension UIButton
{
    func setBackgroundColor(_ aColor: UIColor, for aState: UIControlState) -> Void
    {
        self.setBackgroundImage(UIImage.resizableImageWith(color: aColor), for: aState)
    }
}
