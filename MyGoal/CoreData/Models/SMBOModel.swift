//
//  SMBOModel.swift
//  mygoal
//
//  Created by OLEKSANDR SEMENIUK on 7/4/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit
import CoreData
import VRGSoftSwiftIOSKit

open class SMBOModel: NSManagedObject
{
    static var storage:SMStorage = SMMainStore.shared
    
    static func defaultSortDescriptors() -> [NSSortDescriptor]
    {
        return [NSSortDescriptor.init(key: self.primaryKey, ascending: true)]
    }

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
 
    static func objectByID<T:SMBOModel>(objID: AnyObject) -> T
    {
        var result: T? = nil
        
        self.storage.sync {
            do {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: _entityName())
                request.predicate = NSPredicate(format: "self.\(self.primaryKey) == \(objID)")
                let array = try self.storage.managedObjectContext.fetch(request) as! [T]
                result = array.last
            } catch {
                
            }
        }
        
        return result!
    }

    static func allObjects<T:SMBOModel>() -> [T]
    {
        var result = [T]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: _entityName())
        fetchRequest.sortDescriptors = self.defaultSortDescriptors()
        
        self.storage.sync {
            do {
                let fetchedEntities = try self.storage.managedObjectContext.fetch(fetchRequest) as! [T]
                result = fetchedEntities
            } catch {
                
            }
        }
        
        return result
    }
}
