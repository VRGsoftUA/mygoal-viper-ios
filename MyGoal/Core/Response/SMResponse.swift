//
//  SMResponse.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 1/3/17.
//  Copyright © 2017 OnePlanetOps. All rights reserved.
//

import Foundation

class SMResponse: NSObject
{

    var success: Bool = false
    var code: Int?
    var textMessage: String?
    var dataDictionary: Dictionary<String, AnyObject>?
    var boArray: [AnyObject] = []
    var error: Error?
    var requestCancelled: Bool = false

    override init()
    {
        super.init()
        
        dataDictionary = Dictionary()
    }
}
