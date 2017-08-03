//
//  SMTitledID.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 01/31/17.
//  Copyright © 2016 OnePlanetOps. All rights reserved.
//

import Foundation

open class SMTitledID : AnyObject
{
    var ID : AnyObject?
    var title : String?

    
    init(ID aID: AnyObject?, title aTitle: String?)
    {
        ID = aID
        title = aTitle
    }

    open func copy() -> Any
    {
        let theCopy = SMTitledID(ID: ID, title: title)
        return theCopy
    }
    
    open var description: String
    {
        return "\(String(describing: ID)) \(String(describing: title))"
    }
}
