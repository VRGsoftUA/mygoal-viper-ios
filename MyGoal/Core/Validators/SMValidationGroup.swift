//
//  SMValidationGroup.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 12/23/16.
//  Copyright © 2016 OnePlanetOps. All rights reserved.
//

import Foundation
import UIKit

class SMValidationGroup: AnyObject
{
    var validators: Array<SMValidator> = Array<SMValidator>()

    open func add(validator aValidator: SMValidator) -> Void
    {
        validators.append(aValidator)
    }

    open func add(validators aValidators: Array<SMValidator>) -> Void
    {
        validators.append(contentsOf: aValidators)
    }
    
    open func removeAllValidators() -> Void
    {
        validators.removeAll()
    }
    
    open func validate() -> Array<SMValidationProtocol>
    {
        var result: Array<SMValidationProtocol> = Array<SMValidationProtocol>()
        
        for validator: SMValidator in validators
        {
            if !validator.validate()
            {
                result.append(validator.validatableObject!)
            }
        }
        
        return result
    }
    
    open func applyShakeForWrongFieldsIfCan() -> Void
    {
        for obj: SMValidationProtocol in self.validate()
        {
            if obj is UIView
            {
                (obj as! UIView).transform = CGAffineTransform(translationX: 15, y: 0)
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2, options: UIViewAnimationOptions.curveEaseInOut, animations:
                {
                    (obj as! UIView).transform = CGAffineTransform.identity
                }, completion: nil)
            }
        }
    }
}
