//
//  SMDataBaseRequest.swift
//  mygoal
//
//  Created by OLEKSANDR SEMENIUK on 7/5/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit
import CoreData

class SMDataBaseRequest: SMRequest
{
    var storage: SMStorage?
    var cancelled: Bool
    var executing: Bool
    
    var fetchRequest: NSFetchRequest<NSFetchRequestResult>?
    
    init(storage aStorage: SMStorage)
    {
        self.storage = aStorage
        self.cancelled = false
        self.executing = false
    }
    
    func execute() -> Void
    {
        self.cancelled = false
        self.executing = true
        
        self.storage!.sync(block: {
            let response = self.executeRequest(request: self.fetchRequest!, inContext: (self.storage!._managedObjectContext)!)
            self.executing = false
            self.executeAllResponseBlocks(response: response)
        })
    }
    
    
    //MARK: Request execute
    
    override func canExecute() -> Bool
    {
        return self.storage != nil && self.fetchRequest != nil
    }
    
    override func start()
    {
        self.cancelled = false
        self.executing = true
        
        self.storage!.async(block: {
            if self.cancelled
            {
                let response: SMResponse = SMResponse()
                self.executing = false
                response.requestCancelled = true
                response.success = false
                self.executeAllResponseBlocks(response: response)
                return
            }
        })
        
    }
    
    
    //MARK: 
    
    private func executeRequest(request aRequest: NSFetchRequest<NSFetchRequestResult>, inContext aContext: NSManagedObjectContext) -> SMResponse
    {
        var aError: Error? = nil
        var results = [AnyObject]()
        do {
            results = [try aContext.execute(aRequest)]
        } catch {
            aError = error
        }
        let response = SMResponse()
        if results.count > 0
        {
            response.boArray.append(contentsOf: results)
        }
        response.error = aError
        response.requestCancelled = self.isCancelled()
        response.success = response.error != nil && !response.requestCancelled
        
        return response
    }
    
    override func cancel()
    {
        self.cancelled = true
    }
    
    override func isExecuting() -> Bool
    {
        return self.executing
    }
    
    override func isCancelled() -> Bool
    {
        return self.cancelled
    }

}
