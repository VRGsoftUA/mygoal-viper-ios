//
//  SMFetcherIntoStorage.swift
//  mygoal
//
//  Created by OLEKSANDR SEMENIUK on 7/12/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

class SMFetcherIntoStorage: SMFetcherWithRequest
{
    var storage: SMStorage?
    
    var clearStorageBeforeSave: Bool
    var fetchOnlyFromDataBase: Bool
    var fetchFromDataBaseWhenGatewayRequestFailed: Bool
    var fetchFromDataBaseWhenGatewayRequestSuccess: Bool
    var fetchedModelsContainsDifferentEntities: Bool
    var dontSaveIntoStorageAfterFetchFromGateway: Bool
    
    var currentMessage: SMFetcherMessage?
    
    init(storage aStorage: SMStorage)
    {
        self.storage = aStorage
        self.clearStorageBeforeSave = false
        self.fetchOnlyFromDataBase = false
        self.fetchFromDataBaseWhenGatewayRequestFailed = false
        self.fetchFromDataBaseWhenGatewayRequestSuccess = false
        self.fetchedModelsContainsDifferentEntities = false
        self.dontSaveIntoStorageAfterFetchFromGateway = false
    }
    
    
    //MARK: Request
    
    func setRequestWith(_ aRequest: SMRequest) -> Void
    {
        assert(self.callbackQueue != nil, "SMFetcherWithRequest: callbackQueue is nil! Setup callbackQueue before setup request.")
        
        if request == aRequest { return }
        
        self.cancelFetching()
        request = aRequest
        
        let _: SMRequest = request!.addResponseBlock({[unowned self] (aResponse) in
            if aRequest.isKind(of: SMGatewayRequest.self)
            {
                let success: Bool = aResponse.success
                if success
                {
                    let models = self.processFetchedModelsAfterGatewayInResponse(aResponse)
                    aResponse.boArray = models
                    
                    if self.fetchFromDataBaseWhenGatewayRequestSuccess && self.canFetchFromDatabaseForFailedResponse(aResponse)
                    {
                        self.request = self.dataBaseRequestByMessage(self.currentMessage!)
                        if self.request != nil
                        {
                            self.request?.start()
                        } else
                        {
                            aResponse.boArray = self.processFetchedModelsIn(response: aResponse)
                            
                            if self.fetchCallback != nil
                            {
                                self.fetchCallback!(aResponse)
                            }
                        }
                    } else
                    {
                        aResponse.boArray = self.processFetchedModelsIn(response: aResponse)
                        
                        if self.fetchCallback != nil
                        {
                            self.fetchCallback!(aResponse)
                        }
                    }
                } else if self.fetchFromDataBaseWhenGatewayRequestFailed && !aResponse.requestCancelled && self.canFetchFromDatabaseForFailedResponse(aResponse)
                {
                    self.request = self.dataBaseRequestByMessage(self.currentMessage!)
                    if self.request != nil
                    {
                        self.request?.start()
                    } else
                    {
                        aResponse.boArray = self.processFetchedModelsIn(response: aResponse)
                        
                        if self.fetchCallback != nil
                        {
                            self.fetchCallback!(aResponse)
                        }
                    }
                } else
                {
                    aResponse.boArray = self.processFetchedModelsIn(response: aResponse)
                    
                    if self.fetchCallback != nil
                    {
                        self.fetchCallback!(aResponse)
                    }
                }
                
            } else
            {
                aResponse.boArray = self.processFetchedModelsIn(response: aResponse)
                
                if self.fetchCallback != nil
                {
                    self.fetchCallback!(aResponse)
                }
            }
        }, responseQueue: self.callbackQueue!)
    }
    
    override func preparedRequestBy(message aMessage: SMFetcherMessage) -> SMRequest?
    {
        if currentMessage == aMessage
        {
            return preparedRequest!
        }
        
        currentMessage = aMessage
        
        var newRequest: SMRequest
        if !fetchOnlyFromDataBase
        {
            if SMGatewayConfigurator.shared.isInternetReachable()
            {
                newRequest = self.gatewayRequestByMessage(aMessage)!
            } else
            {
                newRequest = self.dataBaseRequestByMessage(aMessage)!
            }
        } else
        {
            newRequest = self.dataBaseRequestByMessage(aMessage)!
        }
        return newRequest
    }
    
    func gatewayRequestByMessage(_ aMessage: SMFetcherMessage) -> SMGatewayRequest?
    {
        //override it
        return nil
    }
    
    func dataBaseRequestByMessage(_ aMessage: SMFetcherMessage) -> SMDataBaseRequest?
    {
        //override it
        return nil
    }
    
    
    //MARK: Fetch
    
    override func fetchDataBy(_ aMessage: SMFetcherMessage, _ aFetchCallback: @escaping SMDataFetchCallback)
    {
        fetchCallback = aFetchCallback
        
        if preparedRequest == nil
        {
            preparedRequest = self.preparedRequestBy(message: aMessage)
        }
        
        request = preparedRequest
        preparedRequest = nil
        
        request?.start()
    }
    
    func processFetchedModelsAfterGatewayInResponse(_ aResponse: SMResponse) -> [AnyObject]
    {
        return aResponse.boArray
    }
    
    func canFetchFromDatabaseForFailedResponse(_ aResponse: SMResponse) -> Bool
    {
        return true
    }
    
    func canFetchFromDatabaseForSuccessResponse(_ aResponse: SMResponse) -> Bool
    {
        return true
    }
}

