//
//  UIImage+Help.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 1/18/17.
//  Copyright © 2017 OnePlanetOps. All rights reserved.
//

import UIKit

extension UIImage
{
    class func imageWith(color aColor: UIColor, size aSize: CGSize) -> UIImage!
    {
        let rect: CGRect = CGRect(origin: CGPoint(), size: aSize)
        UIGraphicsBeginImageContext(rect.size)
        
        let context: CGContext  =  UIGraphicsGetCurrentContext()!

        context.setFillColor(aColor.cgColor)
        context.fill(rect)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func sm_tintedImageWith(color aColor: UIColor) -> UIImage
    {
        var result: UIImage
        
        let scale: CGFloat = self.scale
        let size: CGSize = CGSize(width: scale*self.size.width, height: scale*self.size.height)
        UIGraphicsBeginImageContext(size)
        
        let context: CGContext  =  UIGraphicsGetCurrentContext()!

        context.translateBy(x: 0.0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        context.setBlendMode(CGBlendMode.normal)
        context.draw(self.cgImage!, in: rect)
        context.setBlendMode(CGBlendMode.sourceIn)
        context.setFillColor(aColor.cgColor)
        context.fill(rect)
        let image: CGImage = context.makeImage()!
        
        result = UIImage(cgImage: image, scale: scale, orientation: self.imageOrientation)
        
        return result
    }
    
    class func resizableImageWith(color aColor: UIColor) -> UIImage!
    {
        let image: UIImage = self.imageWith(color: aColor, size: CGSize(width: 1, height: 1)).resizableImage(withCapInsets: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0), resizingMode: UIImageResizingMode.stretch)
        return image
    }
    
    var roundedImage: UIImage
    {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        UIBezierPath(roundedRect: rect, cornerRadius: self.size.height).addClip()
        self.draw(in: rect)
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}
