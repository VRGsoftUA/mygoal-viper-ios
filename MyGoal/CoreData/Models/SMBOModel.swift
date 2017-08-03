//
//  SMBOModel.swift
//  mygoal
//
//  Created by OLEKSANDR SEMENIUK on 7/4/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit
import CoreData

open class SMBOModel: NSManagedObject {
    
    static let primaryKey = "identifier"
    
    var _identifier: NSNumber? {
        set {self.setValue(newValue, forKey: SMBOModel.primaryKey)}
        get {return self.value(forKey: SMBOModel.primaryKey) as? NSNumber}
    }
    
    static func keyId() -> String {
        return "id"
    }
    
    static func _entityName() -> String {
        return String(describing: self)
    }
    
}
