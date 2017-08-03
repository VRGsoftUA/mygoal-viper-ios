//
//  UIView+Help.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 4/11/17.
//  Copyright © 2017 Contractors.com. All rights reserved.
//

import UIKit

extension UIView
{
    class func loadFromNib() -> UIView
    {
        let result: UIView = Bundle.main.loadNibNamed(String(describing: self), owner: self, options: nil)?.last as! UIView
        
        return result
    }

    func sm_roundBorder() -> Void
    {
        self.layer.cornerRadius = self.frame.size.height/2.0;
        self.layer.masksToBounds = true;
    }
    
    func sm_showAnimate(_ aAnimate: Bool) -> Void
    {
        if aAnimate
        {
            self.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 1
            }, completion: { (finished) in
                if finished
                {
                    self.alpha = 1
                }
            })
        } else
        {
            self.alpha = 1
            self.isHidden = false
        }
    }
    
    func sm_hideAnimate(_ aAnimate: Bool) -> Void
    {
        if aAnimate
        {
            UIView.animate(withDuration: 0.2, animations: { 
                self.alpha = 0
            }, completion: { (finished) in
                if finished
                {
                    self.alpha = 0
                    self.isHidden = true
                }
            })
        } else
        {
            self.alpha = 0
            self.isHidden = true
        }
    }
}
