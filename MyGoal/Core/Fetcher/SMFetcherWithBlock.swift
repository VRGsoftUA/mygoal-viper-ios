//
//  SMFetcherWithBlock.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 3/23/17.
//  Copyright © 2017 Contractors.com. All rights reserved.
//

import UIKit

typealias SMDataFetchBlock = (SMFetcherMessage, @escaping SMDataFetchCallback) -> Void


class SMFetcherWithBlock: AnyObject, SMDataFetcherProtocol
{
    // MARK: SMDataFetcherProtocol
    
    var callbackQueue: DispatchQueue?
    
    var fetchBlock: SMDataFetchBlock?
    
    
    init(fetchBlock aFetchBlock: @escaping SMDataFetchBlock)
    {
        self.fetchBlock = aFetchBlock
    }
    
    func canFetchWith(message aMessage: SMFetcherMessage) -> Bool
    {
        return fetchBlock != nil
    }
    
    func fetchDataBy(message aMessage: SMFetcherMessage, withCallback aFetchCallback: @escaping SMDataFetchCallback) -> Void
    {
        assert(self.fetchBlock != nil)
        self.callbackQueue?.async
            {
                self.fetchBlock!(aMessage, aFetchCallback)
        }
    }
    
    func cancelFetching() -> Void
    {
        
    }
}
