//
//  SMModuleList.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 2/2/17.
//  Copyright © 2017 OnePlanetOps. All rights reserved.
//

import UIKit

typealias SMModuleListFetcherFailedCallback = (SMModuleList, SMResponse) -> Void
typealias SMModuleListFetcherCantFetch = (SMModuleList, SMFetcherMessage) -> Void


@objc protocol SMModuleListDelegate: NSObjectProtocol
{
    @objc optional func fetcherMessageFor(moduleList aModule: SMModuleList) -> SMFetcherMessage
    @objc optional func willReload(moduleList aModule: SMModuleList) -> Void
    @objc optional func moduleList(_ aModule: SMModuleList, processFetchedModelsInResponse aResponse: SMResponse) -> [AnyObject]
    @objc optional func prepareSectionsFor(moduleList aModule: SMModuleList) -> Void
    @objc optional func moduleList(_ aModule: SMModuleList, sectionForModels aModels: [AnyObject], indexOfSection aIndex: Int) -> SMSectionReadonly
    @objc optional func moduleList(_ aModule: SMModuleList, didReloadDataWithModels aModels: [AnyObject]) -> Void
}

class SMModuleList: NSObject
{
    var moduleQueue: DispatchQueue = DispatchQueue(label: "SMModuleList.Queue")
    var lastUpdateDate: Date?
    var models: [AnyObject] = []
    
    var tableDisposer: SMTableDisposerModeled?
    
    var isReloading : Bool = false
    
    var pullToRefreshAdapter: SMPullToRefreshAdapter?
    {
        didSet
        {
            weak var __self = self
            pullToRefreshAdapter?.refreshCallback = { (aPullToRefreshAdapter: SMPullToRefreshAdapter) in
                
                if __self != nil
                {
                    if !__self!.isUseActivityAdapterWithPullToRefreshAdapter
                    {
                        __self!.isHideActivityAdapterForOneFetch = true
                    }
                    
                    __self!.reloadData()
                }
            }
        }
    }
    var activityAdapter: SMActivityAdapter?
    var isUseActivityAdapterWithPullToRefreshAdapter: Bool = false
    var isHideActivityAdapterForOneFetch: Bool = false
    var fetcherMessageClass: AnyClass? { get {return SMFetcherMessage.self} }
    var fetcherFailedCallback: SMModuleListFetcherFailedCallback?
    var fetcherCantFetchCallback: SMModuleListFetcherCantFetch?
    
    
    weak var delegate: SMModuleListDelegate?
    
    var dataFetcher: SMDataFetcherProtocol?
    {
        didSet
        {
            dataFetcher?.callbackQueue = self.moduleQueue
        }
    }
    
    required init(tableDisposer aTableDisposer: SMTableDisposerModeled)
    {
        super.init()
        
        self.tableDisposer = aTableDisposer
    }
    
    open func reloadData() -> Void
    {
        if isReloading
        {
            return
        }
        
        isReloading = true
        self.models.removeAll()
        
        if self.delegate != nil && self.delegate!.willReload(moduleList:) != nil
        {
            self.delegate!.willReload!(moduleList: self)
        }
        
        self.fetchDataWith(message: self.createFetcherMessage())
    }
    
    open func configureWith(scrollView aScrollView: UIScrollView) -> Void
    {
        pullToRefreshAdapter?.configureWith(scrollView: aScrollView)
        activityAdapter?.configureWith(view: aScrollView)
    }

    func processFetchedModelsIn(response aResponse: SMResponse) -> [AnyObject]
    {
        var result: [AnyObject]? = nil
        
        if self.delegate != nil && self.delegate!.moduleList(_:processFetchedModelsInResponse:) != nil
        {
            result = self.delegate!.moduleList!(self, processFetchedModelsInResponse: aResponse)
        } else
        {
            result = aResponse.boArray
        }

        return result!
    }

    func prepareSections() -> Void
    {
        if self.delegate != nil
        {
            if self.delegate!.responds(to: #selector(SMModuleListDelegate.prepareSectionsFor(moduleList:)))
            {
                self.delegate!.prepareSectionsFor!(moduleList: self)
            } else if self.delegate!.responds(to: #selector(SMModuleListDelegate.moduleList(_:sectionForModels:indexOfSection:)))
            {
                self.tableDisposer!.sections.removeAll()
            }
        } else
        {
            self.tableDisposer!.sections.removeAll()
            let section = SMSectionReadonly()
            self.tableDisposer!.addSection(section)
        }
    }
    
    func fetchDataWith(message aMessage: SMFetcherMessage) -> Void
    {
        
        if self.dataFetcher != nil && self.dataFetcher!.canFetchWith(message: aMessage)
        {
            self.dataFetcher?.cancelFetching()
            self.willFetchDataWith(message: aMessage)
            weak var __self = self

            self.dataFetcher?.fetchDataBy(message: aMessage, withCallback: { (aResponse: SMResponse) in
                DispatchQueue.main.sync {
                    
                    __self?.didFetchDataWith(message: aMessage, response: aResponse)
                    
                    if aResponse.success
                    {
                        let aModels: [AnyObject] = (__self?.processFetchedModelsIn(response: aResponse))!
                        
                        __self?.prepareSections()
                        
                        var numberOfPrepareSections: Int = 0
                        
                        if aModels.count != 0
                        {
                            for var i in (0..<aModels.count)
                            {
                                let obj: AnyObject = aModels[i]
                                
                                var ms: [AnyObject]
                                
                                if obj is [AnyObject]
                                {
                                    ms = obj as! [AnyObject]
                                } else
                                {
                                    var mutMs: [AnyObject] = []
                                    for j in (i..<aModels.count)
                                    {
                                        i = j
                                        
                                        if !(aModels[j] is [AnyObject])
                                        {
                                            mutMs.append(aModels[j])
                                        } else
                                        {
                                            i -= 1
                                            break
                                        }
                                    }
                                    
                                    ms = mutMs
                                }
                                __self?.updateSectionWith(models: ms, sectionIndex: numberOfPrepareSections)
                                numberOfPrepareSections += 1
                            }
                        } else
                        {
                            __self?.updateSectionWith(models: aModels, sectionIndex: numberOfPrepareSections)
                            numberOfPrepareSections += 1
                        }
                        
                        __self?.tableDisposer!.reloadData()
                        
                        if __self?.delegate != nil && __self!.delegate!.responds(to: #selector(SMModuleListDelegate.moduleList(_:didReloadDataWithModels:)))
                        {
                            __self!.delegate?.moduleList!(__self!, didReloadDataWithModels: aModels)
                        }
                    } else
                    {
                        if !aResponse.requestCancelled && __self?.fetcherFailedCallback != nil
                        {
                            __self?.fetcherFailedCallback!(__self!,aResponse)
                        }
                    }
                }
            })
        } else
        {
            self.pullToRefreshAdapter?.endPullToRefresh()
            
            if self.fetcherCantFetchCallback != nil
            {
                self.fetcherCantFetchCallback!(self,aMessage)
            }
        }
    }
    
    func createFetcherMessage() -> SMFetcherMessage
    {
        var message: SMFetcherMessage?
        
        if self.delegate != nil && self.delegate!.fetcherMessageFor(moduleList:) != nil
        {
            message = self.delegate!.fetcherMessageFor!(moduleList: self)
            print(type(of: message))
            print(type(of: self.fetcherMessageClass))
            
            if !(message?.isMember(of: self.fetcherMessageClass!))!
            {
                assert(false, "Wrong fetcher message class!")
            }
        } else
        {
            message = (self.fetcherMessageClass as! SMFetcherMessage.Type).init()
        }

        return message!
    }
    
    func updateSectionWith(models aModels: [AnyObject], sectionIndex aSectionIndex: Int) -> Void
    {
        var sectionForModels: SMSectionReadonly? = nil
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMModuleListDelegate.moduleList(_:sectionForModels:indexOfSection:)))
        {
            sectionForModels = self.delegate!.moduleList!(self, sectionForModels: aModels, indexOfSection: aSectionIndex)
        }
        
        if sectionForModels == nil
        {
            sectionForModels = self.tableDisposer?.sections.last
        }

        self.setupModels(aModels, forSection: sectionForModels!)
    }
    
    func setupModels(_ aModels: [AnyObject], forSection aSection: SMSectionReadonly) -> Void
    {
        self.models += aModels
        
        self.tableDisposer!.setupModels(aModels, forSection: aSection)
    }
    
    func willFetchDataWith(message aMessage: SMFetcherMessage) -> Void
    {
        if !self.isHideActivityAdapterForOneFetch
        {
            self.isHideActivityAdapterForOneFetch = false
            DispatchQueue.main.async {
                self.activityAdapter?.show()
            }
        }
    }
    
    func didFetchDataWith(message aMessage: SMFetcherMessage, response aResponse: SMResponse) -> Void
    {
        self.isReloading = false
        self.activityAdapter?.hide()
        self.pullToRefreshAdapter?.endPullToRefresh()
    }
}
