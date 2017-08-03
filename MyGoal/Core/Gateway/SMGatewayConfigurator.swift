//
//  SMGatewayConfigurator.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 1/4/17.
//  Copyright © 2017 OnePlanetOps. All rights reserved.
//

import Foundation
import Alamofire

class SMGatewayConfigurator: AnyObject
{
    static var shared: SMGatewayConfigurator = SMGatewayConfigurator()

    var gateways: [SMGateway] = []
    var networkReachabilityManager: NetworkReachabilityManager?
    
    func isInternetReachable() -> Bool
    {
        let result: Bool = networkReachabilityManager!.isReachable
        return result
    }
    
    func register(gateway aGateway: SMGateway) -> Void
    {
        gateways.append(aGateway)
    }
    
    func configureGatewaysWithBase(url aUrl: URL) -> Void
    {
        networkReachabilityManager = NetworkReachabilityManager(host: aUrl.absoluteString)
        networkReachabilityManager?.startListening()
        
        for g in gateways
        {
            g.configureWithBase(url: aUrl)
        }
    }
}
