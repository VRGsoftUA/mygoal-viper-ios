//
//  SMGateway.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 1/4/17.
//  Copyright © 2017 OnePlanetOps. All rights reserved.
//

import Foundation
import Alamofire

class SMGateway: AnyObject
{
    var defaultParameters: [String: AnyObject] = [:]
    var defaultHeaders: [String: String] = [:]

    var baseUrl: URL?
    var parameterEncoding: JSONEncoding = JSONEncoding.default
    
    var requests: [SMGatewayRequest] = []
    
    func isInternetReachable() -> Bool
    {
        return SMGatewayConfigurator.shared.isInternetReachable()
    }
    
    func configureWithBase(url aUrl: URL) -> Void
    {
        baseUrl = aUrl
    }
    
    func start(request aRequest: SMGatewayRequest) -> Void
    {
        aRequest.getDataRequest().resume()
        
        self.retainRequest(aRequest)
    }
    
    func defaultFailureBlockFor(request aRequest: SMGatewayRequest) -> SMGatewayRequestFailureBlock
    {
        func result(data: DataRequest,error: Error) -> SMResponse
        {
            let response: SMResponse = SMResponse()
            response.success = false
            response.textMessage = error.localizedDescription
            
            return response
        }

        return result
    }
    
    
    // MARK: Request Fabric
    
    func request(type aType: HTTPMethod, path aPath: String,parameters aParameters: Dictionary<String, AnyObject>, successBlock aSuccessBlock: @escaping SMGatewayRequestSuccessBlock) -> SMGatewayRequest
    {
        let result: SMGatewayRequest = SMGatewayRequest(gateway: self)
        
        result.path = aPath
        result.type = aType
        result.parameters = aParameters
        
        let failureBlock: SMGatewayRequestFailureBlock = self.defaultFailureBlockFor(request: result)
        
        result.setup(successBlock: aSuccessBlock, failureBlock: failureBlock)
        
        return result
    }
    
    // MARK: - Retain-Release Requests
    
    func retainRequest(_ aRequest: SMGatewayRequest) -> Void
    {
        requests.append(aRequest)
    }
    
    func releaseRequest(_ aRequest: SMGatewayRequest) -> Void
    {
        requests.remove(at: requests.index(of: aRequest)!)
    }
}
