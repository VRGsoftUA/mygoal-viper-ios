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

class SMMainStore: SMStorage {
    
    static let shared = SMMainStore()
    
    override func persistentStoreName() -> String? {
        return "DataModel.sqlite"
    }
    
    func objectByID(objID: AnyObject, entity: SMBOModel.Type) -> NSManagedObject {
        var object: NSManagedObject? = nil
        
        self.sync {
            do {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity._entityName())
                request.predicate = NSPredicate(format: "self.\(entity.primaryKey) == \(objID)")
                let array = try self.managedObjectContext.fetch(request) as! [NSManagedObject]
                object = array.last
            } catch {
                
            }
        }
        
        return object!
    }
    
    func allObjects(entityName: String) -> [NSManagedObject] {
        var result = [NSManagedObject]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.sortDescriptors = self.defaultSortDescriptors()
        
        self.sync {
            do {
                let fetchedEntities = try self.managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
                result = fetchedEntities
            } catch {
                
            }
        }
        
        return result
    }
    
    func defaultSortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor.init(key: SMBOGoal.primaryKey, ascending: true)]
    }
    
}

