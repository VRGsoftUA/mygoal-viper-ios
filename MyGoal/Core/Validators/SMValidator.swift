//
//  SMValidator.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 12/22/16.
//  Copyright © 2016 OnePlanetOps. All rights reserved.
//

import Foundation

protocol SMValidationProtocol: AnyObject
{
    var validatableText: String? { get set }
    var validator: SMValidator? { get set }
    func validate() -> Bool
}


open class SMValidator: AnyObject
{
    var _errorMessage: String?
    var errorMessage: String?
    {
        get
        {
            return _errorMessage
        }
        set
        {
            _errorMessage = newValue
        }
    }
    
    var _titleMessage: String?
    var titleMessage: String?
    {
        get
        {
            return _titleMessage
        }
        set
        {
            _titleMessage = newValue
        }
    }

    weak var validatableObject: SMValidationProtocol?
    
    func validate() -> Bool
    {
        return false
    }
}


open class SMCompoundValidator: SMValidator
{
    let validators: Array<SMValidator>!
    var successIfAtLeastOne: Bool = false
    
    init(validators aValidators: Array<SMValidator>)
    {
        validators = aValidators
    }
    
    override func validate() -> Bool
    {
        assert(validators.count != 0, "count of validators should be more than 0")
        
        let result: Bool = (self.successIfAtLeastOne) ? false : true
        
        for validator: SMValidator in validators
        {
            validator.validatableObject = self.validatableObject
           
            let valid: Bool = validator.validate()
            
            if valid && self.successIfAtLeastOne
            {
                return true
            } else if !valid && !self.successIfAtLeastOne
            {
                return false
            }
        }
        
        return result
    }
    
    override var titleMessage: String?
    {
        get
        {
            if _titleMessage != nil
            {
                return _titleMessage
            } else
            {
                return self.firstNotValideValidator?.titleMessage
            }
        }
        
        set
        {
            super.titleMessage = newValue
        }
    }

    override var errorMessage: String?
    {
        get
        {
            if _errorMessage != nil
            {
                return _errorMessage
            } else
            {
                return self.firstNotValideValidator?.errorMessage
            }
        }
        
        set
        {
            super.errorMessage = newValue
        }
    }

    var firstNotValideValidator:SMValidator?
    {
        get
        {
            var result: SMValidator?
            
            for validator: SMValidator in self.validators
            {
                validator.validatableObject = self.validatableObject
                
                let valid: Bool = validator.validate()
                
                if !valid
                {
                    result = validator
                    break
                }
            }
            return result
        }
    }
}
 
open class SMValidatorAny: SMValidator
{
    override func validate() -> Bool
    {
        return true
    }
}

open class SMValidatorIntWithRange: SMValidator
{
    var range: NSRange?
    init(range aRange: NSRange)
    {
        super.init()
        range = aRange
    }
    
    override func validate() -> Bool
    {
        var result: Bool = false
        self.validatableObject?.validatableText = self.validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let intValue: Int = Int(self.validatableObject!.validatableText!)!
        
        result = intValue >= range!.location && intValue <= range!.location + range!.length
        
        return result
    }
}

open class SMValidatorCountNumberInTextWithRange: SMValidator
{
    var range: NSRange?
    init(range aRange: NSRange)
    {
        super.init()
        range = aRange
    }
    
    override func validate() -> Bool
    {
        let result: Bool = false
        assert(result)
        return result
    }
}

open class SMValidatorStringWithRange: SMValidator
{
    var range: NSRange?
    init(range aRange: NSRange)
    {
        super.init()
        range = aRange
    }

    override func validate() -> Bool
    {
        var result: Bool = false
        self.validatableObject?.validatableText = self.validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)

        let length: Int = (self.validatableObject?.validatableText?.characters.count)!
        
        if length >= range!.location && length <= range!.length
        {
            result = true
        }
        
        return result
    }
}

open class SMValidatorEmail: SMValidator
{
    override func validate() -> Bool
    {
        self.validatableObject?.validatableText = self.validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        let mailRegExp: String! = "^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\\.)+(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum)$"
        
        let regExp: NSRegularExpression = try! NSRegularExpression(pattern: mailRegExp, options: NSRegularExpression.Options.caseInsensitive)
        
        var count: Int = 0
        
        if self.validatableObject != nil && self.validatableObject?.validatableText != nil
        {
            count = regExp.numberOfMatches(in: (self.validatableObject?.validatableText)!, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, (self.validatableObject?.validatableText)!.characters.count))
        }
        
        return count == 1
    }
}


open class SMValidatorNotEmpty: SMValidator
{
    override func validate() -> Bool
    {
        self.validatableObject?.validatableText = self.validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        return (self.validatableObject!.validatableText?.characters.count)! > 0
    }
}


open class SMValidatorEqual: SMValidator
{
    let testedValidator: SMValidator
    var isIgnoreCase: Bool
    
    
    init(testedFieldValidator aTestedObject: SMValidationProtocol)
    {
        testedValidator = aTestedObject.validator!
        isIgnoreCase = false
    }

    init(testedValidator aTestedValidator: SMValidator)
    {
        testedValidator = aTestedValidator
        isIgnoreCase = false
    }

    override func validate() -> Bool
    {
        self.validatableObject?.validatableText = self.validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)

        if self.isIgnoreCase
        {
            let result: ComparisonResult! = (self.validatableObject?.validatableText?.compare(testedValidator.validatableObject!.validatableText!, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil))
            
            return result == ComparisonResult.orderedSame
        } else
        {
            return self.validatableObject?.validatableText == testedValidator.validatableObject?.validatableText
        }
    }
}


open class SMValidatorRegExp: SMValidator
{
    let regularExpression: NSRegularExpression!

    init(regExp aRegExp: NSRegularExpression)
    {
        regularExpression = aRegExp
    }
    
    override func validate() -> Bool
    {
        self.validatableObject?.validatableText = self.validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        var count: Int = 0

        if self.validatableObject?.validatableText != nil
        {
            count = regularExpression.numberOfMatches(in: (self.validatableObject?.validatableText)!, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, (self.validatableObject?.validatableText)!.characters.count))
        }
        
        return count == 1
    }
}


open class SMValidatorUSAZipCode: SMValidator
{
    override func validate() -> Bool
    {
        self.validatableObject?.validatableText = self.validatableObject?.validatableText?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        let patern: String! = "^[0-9]+$"
        
        let regExp: NSRegularExpression = try! NSRegularExpression(pattern: patern, options: NSRegularExpression.Options.caseInsensitive)
        
        var count: Int = 0
        
        if self.validatableObject != nil && self.validatableObject?.validatableText != nil && self.validatableObject?.validatableText?.characters.count == 5
        {
            count = regExp.numberOfMatches(in: (self.validatableObject?.validatableText)!, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, (self.validatableObject?.validatableText)!.characters.count))
        }
        
        return count == 1
    }
}
