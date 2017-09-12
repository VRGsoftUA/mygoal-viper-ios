//
//  SMFloatingTextField.swift
//  mygoal
//
//  Created by OLEKSANDR SEMENIUK on 6/21/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//
import UIKit
import VRGSoftSwiftIOSKit

class SMFloatingTextField: SMTextField
{
    var topMargin: CGFloat = 5
    
    var vLine: UIView! = UIView()
    var lbPlaceHolder: UILabel! = UILabel()

    override func setup()
    {
        super.setup()
        
        vLine.frame = CGRect(x: 0, y: self.frame.size.height - 0.5, width: self.frame.size.width, height: 0.5)
        vLine.backgroundColor = SMUIConfigurator.shared.colors.baseSeparator
        vLine.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleWidth]
        self.addSubview(vLine)
        
        lbPlaceHolder.frame = self.bounds
        lbPlaceHolder.backgroundColor = UIColor.clear
        lbPlaceHolder.font = self.font
        lbPlaceHolder.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        lbPlaceHolder.textColor = self.textColor
        self.addSubview(lbPlaceHolder)
        self.layoutIfNeeded()
        
        self.placeholder = super.placeholder
        super.placeholder = nil
        self.updatePlaceHolderFrame()
    }
    
    override var font: UIFont? {
        get {
            return super.font
        }
        set {
            super.font = newValue
            lbPlaceHolder.font = newValue
        }
    }
    
    override var placeholderColor: UIColor? {
        get {
            return lbPlaceHolder.textColor
        }
        set {
            lbPlaceHolder.textColor = newValue
        }
    }

    override var placeholder: String? {
        get {
            return lbPlaceHolder.text
        }
        set {
            lbPlaceHolder.text = newValue
            
            DispatchQueue.main.async {
                self.updatePlaceHolderFrame()
            }
        }
    }

    override var text: String? {
        get {
            return super.text
        }
        set {
            super.text = newValue
            
            DispatchQueue.main.async {
                self.updatePlaceHolderFrame()
            }
        }
    }
    
    override func becomeFirstResponder() -> Bool
    {
        UIView.animate(withDuration: 0.2) {
            var frame = self.bounds
            frame.origin.y = 0
            frame.size.height = self.lbPlaceHolder.font.pointSize
            self.lbPlaceHolder.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
            self.lbPlaceHolder.frame = frame
            self.vLine.frame = CGRect(x: 0, y: self.frame.size.height - 2, width: self.frame.size.width, height: 2.0)
        }
        
        return super.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool
    {
        UIView.animate(withDuration: 0.2) {
            self.updatePlaceHolderFrame()
            self.vLine.frame = CGRect(x: 0, y: self.frame.size.height - 0.5, width: self.frame.size.width, height: 0.5)
        }
        
        return super.resignFirstResponder()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect
    {
        var rect = super.textRect(forBounds: bounds)
        
        rect.origin.y = self.topMargin
        
        return rect
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect
    {
        var rect = super.placeholderRect(forBounds: bounds)
        
        rect.origin.y = self.topMargin
        
        return rect
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect
    {
        var rect = super.editingRect(forBounds: bounds)
        
        rect.origin.y = self.topMargin
        
        return rect
    }
    
    func updatePlaceHolderFrame() -> Void
    {
        if self.text != nil && self.text?.characters.count != 0
        {
            var frame = self.bounds
            frame.origin.y = 0
            frame.size.height = lbPlaceHolder.font.pointSize
            lbPlaceHolder.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
            lbPlaceHolder.frame = frame
        } else
        {
            lbPlaceHolder.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            lbPlaceHolder.frame = self.textRect(forBounds: self.bounds)
        }
    }
}

