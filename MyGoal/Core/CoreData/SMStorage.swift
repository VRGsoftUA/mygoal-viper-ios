//
//  SMStorage.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 12/26/16.
//  Copyright © 2016 OnePlanetOps. All rights reserved.
//

import CoreData

enum SMClonePolicy
{
    case asTemp
    case insertIntoContext
    case asOriginal
}

@available(iOS 9.0, *)
class SMStorage: AnyObject
{
    let storageQueue: DispatchQueue?
    let queueKey = DispatchSpecificKey<Void>()
    
    var _managedObjectContext: NSManagedObjectContext!
    var _persistentStoreCoordinator: NSPersistentStoreCoordinator!
    var _managedObjectModel: NSManagedObjectModel!

    var shouldCacheStorage: Bool = false
    
    init()
    {
        storageQueue = DispatchQueue(label: String(describing: type(of: self)))
        storageQueue!.setSpecific(key:queueKey, value:())
    }
    
    var persistentStoreCoordinator: NSPersistentStoreCoordinator!
    {
        get
        {
            if _persistentStoreCoordinator != nil
            {
                return _persistentStoreCoordinator!
            }
            
            let fileManager: FileManager = FileManager.default
            let directoryURL: URL = fileManager.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last!
            var storeUrl: URL = NSURL.fileURL(withPath: self.persistentStoreName()!, relativeTo: directoryURL)
            
            storeUrl.setTemporaryResourceValue(self.shouldCacheStorage, forKey: URLResourceKey.isExcludedFromBackupKey)
            
            _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            
            do
            {
                try _persistentStoreCoordinator?.addPersistentStore(ofType: self.storeType(), configurationName: nil, at: storeUrl, options: self.migrationPolicy())
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
            
            return _persistentStoreCoordinator
        }
    }
    
    func storeType() -> String
    {
        return NSSQLiteStoreType
    }
    
    func persistentStoreName() -> String?
    {
        return nil
    }
    
    func migrationPolicy() -> [AnyHashable : Any]?
    {
        return [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
    }
    
    func mergeModels() -> Bool
    {
        return true
    }
    
    var managedObjectModel: NSManagedObjectModel
    {
        get
        {
            var result: NSManagedObjectModel!
            
            func block() -> NSManagedObjectModel!
            {
                if _managedObjectModel == nil
                {
                    if !self.mergeModels()
                    {
                        let name: String! = self.persistentStoreName()!.replacingOccurrences(of: ".sqlite", with: "")
                        let modelPath: String! = Bundle.main.path(forResource: name, ofType: "momd")
                        let modelURL: URL = URL(fileURLWithPath: modelPath)
                        
                        _managedObjectModel = NSManagedObjectModel.init(contentsOf: modelURL)
                    } else
                    {
                        _managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])
                    }
                }
                
                return _managedObjectModel
            }
            
            if (DispatchQueue.getSpecific(key: queueKey) != nil)
            {
                result = block()
            } else
            {
                storageQueue?.sync
                {
                    result = block()
                }
            }
            
            return result
        }
    }
    
    var managedObjectContext: NSManagedObjectContext!
    {
        get
        {
//            assert(DispatchQueue.getSpecific(key: queueKey) != nil, "SMStorage - Invoked on incorrect queue")
            
            if _managedObjectContext != nil
            {
                return _managedObjectContext
            } else
            {
                let coordinator: NSPersistentStoreCoordinator? = self.persistentStoreCoordinator
                
                if coordinator != nil
                {
                    _managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
                    _managedObjectContext.persistentStoreCoordinator = coordinator
                    _managedObjectContext.mergePolicy = NSOverwriteMergePolicy
                    _managedObjectContext.undoManager = nil
                }
                
                return _managedObjectContext
            }
        }
    }
    
    func save(isAsync aIsAsync: Bool) -> Void
    {
        let block:(Void)->Void =
        {
            if self.managedObjectContext.hasChanges
            {
                do
                {
                    try self.managedObjectContext.save()
                }
                catch _ as NSError
                {
#if DEBUG
                    abort()
#else
                    self.managedObjectContext.rollback()
#endif
                }
            }
        }
        
        if (DispatchQueue.getSpecific(key: queueKey) != nil)
        {
            block()
        } else
        {
            if aIsAsync
            {
                storageQueue?.async {
                    block()
                }
            } else
            {
                storageQueue?.sync {
                    block()
                }
            }
        }
    }
    
    func save() -> Void
    {
        self.save(isAsync: false)
    }
    
    func saveAsync() -> Void
    {
        self.save(isAsync: true)
    }
    
    func isStorageContained(object anObject: NSManagedObject, compareWith aPredicate: NSPredicate) -> NSManagedObjectID
    {
        var objectID: NSManagedObjectID? = nil
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: anObject.entity.name!)
        request.predicate = aPredicate
        request.resultType = .managedObjectIDResultType
        self.sync {
            do
            {
                let models = try self.managedObjectContext.fetch(request) as! [NSManagedObjectID]
                objectID = models.last
            } catch
            {
                //handle error
            }
            
        }
        
        return objectID!
    }
    
    func clear() -> Void
    {
        let allEntities: [NSEntityDescription] = self.managedObjectModel.entities
        
        for entityDescription in allEntities
        {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
            fetchRequest.entity = entityDescription
            fetchRequest.includesPropertyValues = false
            fetchRequest.includesSubentities = false
            
            do
            {
                let items: [Any] = try self.managedObjectContext.fetch(fetchRequest)
                
                for managedObject in items
                {
                    self.managedObjectContext.delete(managedObject as! NSManagedObject)
                }
            }
            catch let error as NSError
            {
                print(error)
            }
        }
        
        self.save()
    }
    
    func sync(block aBlock: ()->Void) -> Void
    {
        assert(DispatchQueue.getSpecific(key: queueKey) == nil, "SMStorage: Invoked on incorrect queue")
        
        storageQueue?.sync {
            aBlock()
        }
    }

    func async(block aBlock:@escaping ()->Void) -> Void
    {
        assert(DispatchQueue.getSpecific(key: queueKey) == nil, "SMStorage: Invoked on incorrect queue")
        
        storageQueue?.async {
            aBlock()
        }
    }
    
    func object(ofClass aClass: AnyClass, entityName aEntityName: String) -> NSManagedObject
    {
        var result: NSManagedObject?
        self.sync {
            let entity: NSEntityDescription! = NSEntityDescription.entity(forEntityName: aEntityName, in: self.managedObjectContext)
            
            result = (aClass as! NSManagedObject.Type).init(entity: entity, insertInto: self.managedObjectContext)
        }
        
        return result!
    }
    
    func tempObject(ofClass aClass: AnyClass, entityName aEntityName: String) -> NSManagedObject
    {
        var result: NSManagedObject?
        self.sync {
            let entity: NSEntityDescription! = NSEntityDescription.entity(forEntityName: aEntityName, in: self.managedObjectContext)
            
            result = (aClass as! NSManagedObject.Type).init(entity: entity, insertInto: nil)
        }
        
        return result!
    }
    
    func clone(object aObject: NSManagedObject, clonePolicy aClonePolicy: SMClonePolicy = SMClonePolicy.asTemp) -> NSManagedObject
    {
        var result: NSManagedObject!
        
        let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: aObject.entity.name!, in: self.managedObjectContext)!

        switch aClonePolicy
        {
            case SMClonePolicy.asTemp:
                result = (type(of: aObject) as NSManagedObject.Type).init(entity: entity, insertInto: nil)
            break
            
            case SMClonePolicy.insertIntoContext:
                result = (type(of: aObject) as NSManagedObject.Type).init(entity: entity, insertInto: self.managedObjectContext)
            break
            
            case SMClonePolicy.asOriginal:
                result = (type(of: aObject) as NSManagedObject.Type).init(entity: entity, insertInto: aObject.managedObjectContext)
            break
        }
        
        let attributes: [String : NSAttributeDescription] = entity.attributesByName
        
        for attributeName in attributes
        {
            result.setValue(aObject.value(forKey: attributeName.key), forKey: attributeName.key)
        }

        return result
    }
    
    //MARK: Remove entities
    
    func remove(object aObject: NSManagedObject) -> Void
    {
        self.sync {
            self.managedObjectContext.delete(aObject)
        }
    }
    
    func remove(objects aObjects: [NSManagedObject]) -> Void
    {
        self.sync {
            for object in aObjects
            {
                self.managedObjectContext.delete(object)
            }
        }
    }
    
    func removeAllEntitiesWithName(_ anEntityName: String) -> Void
    {
        self.sync {
            let entitiesRequest = NSFetchRequest<NSFetchRequestResult>()
            entitiesRequest.entity = NSEntityDescription.entity(forEntityName: anEntityName, in: self.managedObjectContext)
            entitiesRequest.includesPropertyValues = false
            
            var aError: Error? = nil
            var entities: [AnyObject]
            do
            {
                entities = [try self.managedObjectContext.execute(entitiesRequest)]
                for object in entities
                {
                    self.managedObjectContext.delete(object as! NSManagedObject)
                }
            } catch
            {
                aError = error
            }
            if aError != nil
            {
                print("STStorage: remove entities with error: \(String(describing: aError))")
            }
            
        }
    }
    
    
    //MARK: Object creation
    
    func objectOfClass(_ aClass: AnyClass, _ anEntityName: String) -> NSManagedObject
    {
        var result: NSManagedObject? = nil
        self.sync {
            let entity = NSEntityDescription.entity(forEntityName: anEntityName, in: self.managedObjectContext)
            result = (aClass as! NSManagedObject.Type).init(entity: entity!, insertInto: self._managedObjectContext)
        }
        return result!
    }
    
    func tempObjectOfClass(_ aClass: AnyClass, _ anEntityName: String) -> NSManagedObject
    {
        var result: NSManagedObject? = nil
        self.sync {
            let entity = NSEntityDescription.entity(forEntityName: anEntityName, in: self.managedObjectContext)
            result = (aClass as! NSManagedObject.Type).init(entity: entity!, insertInto: nil)
        }
        return result!
    }
}
