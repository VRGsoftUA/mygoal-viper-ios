//
//  SMFetcherWithRequest.swift
//  mygoal
//
//  Created by OLEKSANDR SEMENIUK on 7/5/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

class SMFetcherWithRequest: NSObject, SMDataFetcherProtocol
{
    deinit
    {
        self.callbackQueue = nil
    }
    
    
    // MARK: SMDataFetcherProtocol
    
    var callbackQueue: DispatchQueue?
    
    var preparedRequest: SMRequest?
    
    var fetchCallback: SMDataFetchCallback?
    
    func canFetchWith(message aMessage: SMFetcherMessage) -> Bool
    {
       return true
    }
    
    func fetchDataBy(message aMessage: SMFetcherMessage, withCallback aFetchCallback: @escaping SMDataFetchCallback)
    {
        
    }
    
    func cancelFetching()
    {
        self.request?.cancel()
    }
    
    
    //MARK: Requests
    
    func preparedRequestBy(message aMessage: SMFetcherMessage) -> SMRequest?
    {
        assert(false, "Override this method!")
        return nil
    }
    
    var _request: SMRequest?
    var request: SMRequest?
    {
        set
        {
            if _request != newValue
            {
                self.cancelFetching()
                _request = newValue
            }
            
            let _ = request!.addResponseBlock({[unowned self] (aResponse) in
                aResponse.boArray = self.processFetchedModelsIn(response: aResponse)
                
                if self.fetchCallback != nil
                {
                    self.fetchCallback!(aResponse)
                }
                
            }, responseQueue: self.callbackQueue!)
        }
        
        get { return _request }
    }
    
    func processFetchedModelsIn(response aResponse: SMResponse) -> [AnyObject]
    {
        return aResponse.boArray
    }
    
    func canFetchWith(_ aMessage: SMFetcherMessage) -> Bool
    {
        if preparedRequest == nil
        {
            preparedRequest = self.preparedRequestBy(message: aMessage)
        }
        return (preparedRequest?.canExecute())!
    }
    
    func fetchDataBy(_ aMessage: SMFetcherMessage, _ aFetchCallback: @escaping SMDataFetchCallback) -> Void
    {
        fetchCallback = aFetchCallback
        if preparedRequest == nil
        {
            preparedRequest = self.preparedRequestBy(message: aMessage)
        }
        _request = preparedRequest
        preparedRequest = nil
        
        _request?.start()
    }
    
}


