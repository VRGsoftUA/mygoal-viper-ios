//
//  SMGatewayRequest.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 1/4/17.
//  Copyright © 2017 OnePlanetOps. All rights reserved.
//

import Foundation
import Alamofire

typealias SMGatewayRequestSuccessBlock = (DataRequest, DataResponse<Any>) -> SMResponse
typealias SMGatewayRequestFailureBlock = (DataRequest, Error) -> SMResponse

class SMGatewayRequest: SMRequest
{
    weak var gateway: SMGateway?
    var dataRequest: DataRequest?
    
    var path: String?
    var type: HTTPMethod?
    var parameters: [String: AnyObject] = [:]
    var headers: [String: String] = [:]
    
    var successBlock: SMGatewayRequestSuccessBlock?
    var failureBlock: SMGatewayRequestFailureBlock?
    
    required init(gateway aGateway: SMGateway)
    {
        super.init()

        gateway = aGateway
        parameters = Dictionary()
    }
    
    override func start() -> Void
    {
        gateway!.start(request: self)
    }
    
    override func cancel()
    {
        dataRequest!.cancel()
    }
    
    override func canExecute() -> Bool
    {
        return gateway!.isInternetReachable()
    }
    
    override func isCancelled() -> Bool
    {
        return dataRequest?.task?.state == URLSessionTask.State.completed
    }
    
    override func isExecuting() -> Bool
    {
        return dataRequest?.task?.state == URLSessionTask.State.running
    }
    
    override func isFinished() -> Bool
    {
        return dataRequest?.task?.state == URLSessionTask.State.completed
    }
    
    func getDataRequest() -> DataRequest
    {
        let fullPath: URL = gateway!.baseUrl!.appendingPathComponent(self.path!)
        
        var allParams: Dictionary<String, Any> = Dictionary()
        
        for (key, value) in (gateway?.defaultParameters)!
        {
            allParams.updateValue(value, forKey: key)
        }

        for (key, value) in (self.parameters)
        {
            allParams.updateValue(value, forKey: key)
        }

        var allHeaders: Dictionary<String, String> = Dictionary()
        
        for (key, value) in (gateway?.defaultHeaders)!
        {
            allHeaders.updateValue(value, forKey: key)
        }
        
        for (key, value) in (self.headers)
        {
            allHeaders.updateValue(value, forKey: key)
        }
        
        dataRequest = Alamofire.request(fullPath, method: self.type!, parameters: allParams, encoding: gateway!.parameterEncoding, headers: allHeaders)
        
        weak var weakSelf = self
                
        dataRequest?.responseJSON(completionHandler: { responseObject in
            switch responseObject.result {
            case .success(let data):
                print("Request success with data: \(data)")
                weakSelf?.executeSuccessBlock(responseObject: responseObject)
            case .failure(let error):
                print("Request failed with error: \(error)")
                weakSelf?.executeFailureBlock(responseObject: responseObject)
            }
        })
        return dataRequest!
    }
    
    func stripData(_ data: Data) -> Data {
        var s = String(data: data, encoding: String.Encoding.ascii) ?? ""
        s = s.replacingOccurrences(of: "\\u0080\\u0093", with: "-")
        let output = s.data(using: String.Encoding.utf8, allowLossyConversion: true) ?? Data()
        return output
    }

    
    func executeSuccessBlock(responseObject aResponseObject: DataResponse<Any>) -> Void
    {
        if successBlock != nil
        {
            let response: SMResponse = successBlock!(self.dataRequest!,aResponseObject)
            
            if self.executeAllResponseBlocksSync
            {
                self.executeSynchronouslyAllResponseBlocks(response: response)
            } else
            {
                self.executeAllResponseBlocks(response: response)
            }
        }
    }
    
    func executeFailureBlock(responseObject aResponseObject: DataResponse<Any>) -> Void
    {
        if failureBlock != nil
        {
            let response: SMResponse = failureBlock!(self.dataRequest!,aResponseObject.error!)
            
            if self.executeAllResponseBlocksSync
            {
                self.executeSynchronouslyAllResponseBlocks(response: response)
            } else
            {
                self.executeAllResponseBlocks(response: response)
            }
        }
    }

    func setup(successBlock aSuccessBlock: @escaping SMGatewayRequestSuccessBlock,failureBlock aFailureBlock: @escaping SMGatewayRequestFailureBlock) -> Void
    {
        self.successBlock = aSuccessBlock
        self.failureBlock = aFailureBlock
    }
}
