//
//  SMPair.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 01/31/17.
//  Copyright © 2016 OnePlanetOps. All rights reserved.
//

import Foundation

class SMPair: AnyObject
{
    var first : AnyObject?
    var second : AnyObject?
    
    init(first aFirst: AnyObject?, second aSecond: AnyObject?)
    {
        first = aFirst
        second = aSecond
    }
    
    open func copy() -> Any
    {
        return SMPair(first: first, second: second)
    }
    
    open var description: String
    {
        return "\(String(describing: first)) \(String(describing: second))"
    }
}


