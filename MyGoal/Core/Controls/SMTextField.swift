//
//  SMTextField.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 12/22/16.
//  Copyright © 2016 OnePlanetOps. All rights reserved.
//

import UIKit

class SMTextField: UITextField, SMValidationProtocol, SMFormatterProtocol
{
    var smdelegate: UITextFieldDelegate?
    
    var delegateHolder: SMTextFieldDelegateHolder?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    open func setup() -> Void
    {
        delegateHolder = SMTextFieldDelegateHolder(textField: self)
        self.delegate = delegateHolder
    }
    
    // MARK: - SMValidationProtocol
    var validatableText: String?
    {
        get
        {
            return self.text
        }
        set
        {
            self.text = newValue
        }
    }
    
    var _validator: SMValidator?
    var validator: SMValidator?
    {
        get
        {
            return _validator
        }
        set
        {
            _validator = newValue
            _validator?.validatableObject = self
        }
    }
    
    func validate() -> Bool
    {
        return ((_validator) != nil) ? _validator!.validate() : true
    }
    
    var _placeholderColor: UIColor?
    var placeholderColor: UIColor?
    {
        set(aPlaceholderColor)
        {
            _placeholderColor = aPlaceholderColor
            
            if self.placeholder != nil && self.placeholderColor != nil
            {
                let atrPlaceholder: NSAttributedString = NSAttributedString(string: self.placeholder!, attributes: [NSForegroundColorAttributeName: placeholderColor as Any])
                self.attributedPlaceholder = atrPlaceholder
            }
        }
        get
        {
            return _placeholderColor
        }
    }
    
    override var placeholder: String?
    {
        set(aPlaceholder)
        {
            super.placeholder = aPlaceholder
            
            if _placeholderColor != nil
            {
                self.placeholderColor = _placeholderColor
            }
        }
        get
        {
            return super.placeholder
        }

    }
//    - (void)setPlaceholderColor:(UIColor *)aPlaceholderColor
//    {
//    placeholderColor = aPlaceholderColor;
//    
//    if (self.placeholder.length)
//    {
//    NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{ NSForegroundColorAttributeName : placeholderColor }];
//    self.attributedPlaceholder = str;
//    }
//    }
//    
//    - (void)setPlaceholder:(NSString *)placeholder
//    {
//    [super setPlaceholder:placeholder];
//    if (placeholderColor)
//    {
//    self.placeholderColor = placeholderColor;
//    }
//    }

    // MARK: - SMFormatterProtocol

    var _formatter: SMFormatter?
    var formatter: SMFormatter?
    {
        get
        {
            return _formatter
        }
        
        set(aFormatter)
        {
            _formatter = aFormatter
            _formatter?.formattableObject = self
        }
    }
    
    var formattingText: String?
    {
        get
        {
            return self.text
        }
        
        set
        {
            self.text = newValue
        }
    }
}

class SMTextFieldDelegateHolder: NSObject, UITextFieldDelegate
{
    weak var holdedTextField: SMTextField?
    
    required init(textField aTextField: SMTextField)
    {
        holdedTextField = aTextField
    }
    
    
    // MARK: - UITextFieldDelegate
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if self.holdedTextField != nil && self.holdedTextField!.smdelegate != nil && (self.holdedTextField!.smdelegate?.responds(to: #selector(UITextFieldDelegate.textFieldShouldBeginEditing(_:))))!
        {
            return self.holdedTextField!.smdelegate!.textFieldShouldBeginEditing!(textField)
        }
        
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if self.holdedTextField != nil && self.holdedTextField!.smdelegate != nil && (self.holdedTextField!.smdelegate?.responds(to: #selector(UITextFieldDelegate.textFieldDidBeginEditing(_:))))!
        {
            self.holdedTextField!.smdelegate!.textFieldDidBeginEditing!(textField)
        }
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        if self.holdedTextField != nil && self.holdedTextField!.smdelegate != nil && (self.holdedTextField!.smdelegate?.responds(to: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:))))!
        {
            return self.holdedTextField!.smdelegate!.textFieldShouldEndEditing!(textField)
        }
        
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField)
    {
        if self.holdedTextField != nil && self.holdedTextField!.smdelegate != nil && (self.holdedTextField!.smdelegate?.responds(to: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:))))!
        {
            self.holdedTextField!.smdelegate!.textFieldDidEndEditing!(textField)
        }
    }
    
    @available(iOS 10.0, *)
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason)
    {
        if self.holdedTextField != nil && self.holdedTextField!.smdelegate != nil && (self.holdedTextField!.smdelegate?.responds(to: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:reason:))))!
        {
            self.holdedTextField!.smdelegate!.textFieldDidEndEditing!(textField, reason: reason)
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        var result: Bool = true
        
        if result && self.holdedTextField != nil && self.holdedTextField!.formatter != nil
        {
            result = self.holdedTextField!.formatter!.formatWithNewCharactersIn(range: range, replacementString: string)
        }

        if result && self.holdedTextField != nil && self.holdedTextField!.smdelegate != nil && (self.holdedTextField!.smdelegate?.responds(to: #selector(UITextFieldDelegate.textField(_:shouldChangeCharactersIn:replacementString:))))!
        {
            result = self.holdedTextField!.smdelegate!.textField!(textField, shouldChangeCharactersIn: range, replacementString: string)
        }
        
        return result
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        if self.holdedTextField != nil && self.holdedTextField!.smdelegate != nil && (self.holdedTextField!.smdelegate?.responds(to: #selector(UITextFieldDelegate.textFieldShouldClear(_:))))!
        {
            return self.holdedTextField!.smdelegate!.textFieldShouldClear!(textField)
        }
        
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if self.holdedTextField != nil && self.holdedTextField!.smdelegate != nil && (self.holdedTextField!.smdelegate?.responds(to: #selector(UITextFieldDelegate.textFieldShouldReturn(_:))))!
        {
            return self.holdedTextField!.smdelegate!.textFieldShouldReturn!(textField)
        }
        
        return true
    }
}

