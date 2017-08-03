//
//  SMTextView.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 12/22/16.
//  Copyright © 2016 OnePlanetOps. All rights reserved.
//

import UIKit

class SMTextView: UITextView, SMValidationProtocol
{
    
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
}
