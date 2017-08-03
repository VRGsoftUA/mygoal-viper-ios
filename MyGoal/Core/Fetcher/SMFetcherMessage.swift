//
//  SMFetcherMessage.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 2/3/17.
//  Copyright © 2017 OnePlanetOps. All rights reserved.
//

import UIKit

class SMFetcherMessage: NSObject
{
    let defaultParameters: [String: AnyObject] = [:]
    
    required override init()
    {
        super.init()
    }
}


class SMFetcherMessagePaging: SMFetcherMessage
{
    var pagingSize: Int = 0
    var pagingOffset: Int = 0
    
    var reloading: Bool = false
    var loadingMore: Bool = false
}

//@property (nonatomic, assign) NSUInteger pagingSize;
//@property (nonatomic, assign) NSUInteger pagingOffset;
//@property (nonatomic, assign) BOOL reloading;
//@property (nonatomic, assign) BOOL loadingMore;
