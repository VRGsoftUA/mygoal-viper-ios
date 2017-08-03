//
//  SMDataFetcherProtocol.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 2/3/17.
//  Copyright © 2017 OnePlanetOps. All rights reserved.
//

import Foundation

typealias SMDataFetchCallback = (SMResponse) -> Void


protocol SMDataFetcherProtocol
{
    var callbackQueue: DispatchQueue? {get set}
    
    func canFetchWith(message aMessage: SMFetcherMessage) -> Bool
    func fetchDataBy(message aMessage: SMFetcherMessage, withCallback aFetchCallback: @escaping SMDataFetchCallback) -> Void
    func cancelFetching() -> Void;
}
