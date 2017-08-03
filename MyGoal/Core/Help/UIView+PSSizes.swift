//
//  UIView+PSSizes.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 1/14/17.
//  Copyright © 2017 OnePlanetOps. All rights reserved.
//

import UIKit

extension UIView
{
//    open var left: CGFloat
//    {
//        get
//        {
//            return self.frame.origin.x
//        }
//        set(left)
//        {
//            var frame: CGRect = self.frame
//            frame.origin.x = left
//            self.frame = frame
//        }
//    }
//    
//    open var top: CGFloat
//    {
//        get
//        {
//            return self.frame.origin.y
//        }
//        set(top)
//        {
//            var frame: CGRect = self.frame
//            frame.origin.y = top
//            self.frame = frame
//        }
//    }
//
//    open var right: CGFloat
//    {
//        get
//        {
//            return self.frame.origin.x + self.frame.size.width
//        }
//        set(right)
//        {
//            var frame: CGRect = self.frame
//            frame.origin.x = right - frame.size.width
//            self.frame = frame
//        }
//    }
//    
//    open var bottom: CGFloat
//    {
//        get
//        {
//            return self.frame.origin.y + self.frame.size.height
//        }
//        set(bottom)
//        {
//            var frame: CGRect = self.frame
//            frame.origin.y = bottom - frame.size.height
//            self.frame = frame
//        }
//    }
//    
//    open var width: CGFloat
//    {
//        get
//        {
//            return self.frame.size.width
//        }
//        set(width)
//        {
//            var frame: CGRect = self.frame
//            frame.size.width = width
//            self.frame = frame
//        }
//    }
//
//    open var height: CGFloat
//    {
//        get
//        {
//            return self.frame.size.height
//        }
//        set(height)
//        {
//            var frame: CGRect = self.frame
//            frame.size.height = height
//            self.frame = frame
//        }
//    }
//
//    open var origin: CGPoint
//    {
//        get
//        {
//            return self.frame.origin
//        }
//        set(origin)
//        {
//            var frame: CGRect = self.frame
//            frame.origin = origin
//            self.frame = frame
//        }
//    }
//
//    open var size: CGSize
//    {
//        get
//        {
//            return self.frame.size
//        }
//        set(size)
//        {
//            var frame: CGRect = self.frame
//            frame.size = size
//            self.frame = frame
//        }
//    }
//    
//    open var rightMargin: CGFloat
//    {
//        get
//        {
//            return self.superview!.width - self.frame.size.width - self.frame.origin.x
//        }
//        set(rightMargin)
//        {
//            let sWidth: CGFloat = self.superview!.frame.size.width
//            
//            var frame: CGRect = self.frame
//            frame.origin.x = sWidth - rightMargin - frame.size.width
//            self.frame = frame
//        }
//    }
//    
//    open var bottomMargin: CGFloat
//    {
//        get
//        {
//            return self.superview!.height - self.frame.size.height - self.frame.origin.y
//        }
//        set(bottomMargin)
//        {
//            let sHeight: CGFloat = self.superview!.frame.size.height
//            
//            var frame: CGRect = self.frame
//            frame.origin.y = sHeight - bottomMargin - frame.size.height
//            self.frame = frame
//        }
//    }
    
    func sm_updateConstrainIfExist(height aHeight: CGFloat) -> Void
    {
        for constraint in self.constraints
        {
            if constraint.firstAttribute == NSLayoutAttribute.height
            {
                constraint.constant = aHeight
                break
            }
        }
    }

    func sm_updateConstrainIfExist(width aWidth: CGFloat) -> Void
    {
        for constraint in self.constraints
        {
            if constraint.firstAttribute == NSLayoutAttribute.width
            {
                constraint.constant = aWidth
                break
            }
        }
    }
}
