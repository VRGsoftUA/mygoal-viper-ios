//
//  SMTargetAction.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 01/31/17.
//  Copyright © 2016 OnePlanetOps. All rights reserved.
//

import Foundation

open class SMTargetAction : AnyObject
{
    weak var target: AnyObject?
    var action: Selector?
    
    init(target aTarget: AnyObject, action aAction: Selector)
    {
        self.target = aTarget
        self.action = aAction
    }

    open func set(target aTarget: AnyObject, action aAction: Selector) -> Void
    {
        target = aTarget
        action = aAction
    }
    
    open func sendActionFrom(sender aSender: Any) -> Void
    {
        if target!.responds(to: action)
        {
            _ = target!.perform(action!, with: aSender)
        }
    }
}


typealias SMBlockActionBlock = (Any) -> Void
open class SMBlockAction : AnyObject
{
    var block: SMBlockActionBlock?
    
    init(block aBlock: @escaping SMBlockActionBlock)
    {
        self.block = aBlock
    }
    
    open func performBlockFrom(sender aSender: Any) -> Void
    {
        self.block!(aSender)
    }
}
