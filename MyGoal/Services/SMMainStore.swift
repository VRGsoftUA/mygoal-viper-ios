//
//  SMMainStorage.swift
//  mygoal
//
//  Created by OLEKSANDR SEMENIUK on 7/4/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit
import CoreData
import VRGSoftSwiftIOSKit

class SMMainStore: SMStorage
{
    static let shared = SMMainStore()
    
    override func persistentStoreName() -> String?
    {
        return "DataModel.sqlite"
    }
}

