//
//  SMModuleListPaging.swift
//  semenag01kit_Swift
//
//  Created by OLEKSANDR SEMENIUK on 7/6/17.
//  Copyright © 2017 semenag01. All rights reserved.
//

import UIKit

@objc protocol SMPagingMoreCellDataProtocol: NSObjectProtocol
{
    @objc optional func addTarget(_ aTarget: Any, action aAction:Selector)
}

@objc protocol SMPagingMoreCellProtocol: NSObjectProtocol
{
    @objc optional func didBeginDataLoading()
    @objc optional func didEndDataLoading()
}

@objc protocol SMModuleListPagingDelegate: NSObjectProtocol
{
    @objc optional func moreCellDataForPaging(moduleList aModuleList: SMModuleListPaging) -> SMPagingMoreCellDataProtocol
    @objc optional func willLoadMore(moduleList aModuleList: SMModuleListPaging)
}


class SMModuleListPaging: SMModuleList, SMTableDisposerMulticastDelegate
{
    var initialPageOffset : Int = 0
    var isItemsAsPage : Bool = false
    var pageOffset : Int = 0
    var pageSize : Int = 20
    var isLoadMoreDataAuto : Bool = true
    var isLoadingMore : Bool = false
    
    var moreCell: SMPagingMoreCellProtocol?
    
    override var fetcherMessageClass: AnyClass? { get {return SMFetcherMessagePaging.self} }
    
    weak var pagingDelegate: SMModuleListPagingDelegate?

    required init(tableDisposer aTableDisposer: SMTableDisposerModeled, initialPageOffset aInitialPageOffset: Int, isItemsAsPage aIsItemsAsPage: Bool)
    {
        super.init(tableDisposer: aTableDisposer)
        
        self.initialPageOffset = aInitialPageOffset
        self.isItemsAsPage = aIsItemsAsPage
        
        self.tableDisposer!.multicastDelegate.addDelegate(self)
    }
    
    required init(tableDisposer aTableDisposer: SMTableDisposerModeled)
    {
        super.init(tableDisposer: aTableDisposer)
        
        self.tableDisposer!.multicastDelegate.addDelegate(self)
    }
    
    override func reloadData()
    {
        if isReloading
        {
            return
        }
        
        let nextMessage: SMFetcherMessagePaging = self.createFetcherMessage() as! SMFetcherMessagePaging
        
        nextMessage.pagingOffset = self.initialPageOffset
        nextMessage.reloading = true
        nextMessage.loadingMore = false
        
        if self.dataFetcher!.canFetchWith(message: nextMessage)
        {
            pageOffset = nextMessage.pagingOffset
            isReloading = nextMessage.reloading
            isLoadingMore = nextMessage.loadingMore
        }
        
        if self.delegate != nil && self.delegate!.willReload(moduleList:) != nil
        {
            self.delegate!.willReload!(moduleList: self)
        }

        self.fetchDataWith(message: nextMessage)
    }
    
    func loadMoreData() -> Void
    {
        if isReloading || isLoadingMore
        {
            return
        }

        if self.pagingDelegate != nil && self.pagingDelegate!.willLoadMore(moduleList:) != nil
        {
            self.pagingDelegate!.willLoadMore!(moduleList: self)
        }
        
        if isItemsAsPage
        {
            pageOffset += 1
        } else
        {
            pageOffset += pageSize
        }
        
        isLoadingMore = true
        
        self.fetchDataWith(message: self.createFetcherMessage())
    }

    override func createFetcherMessage() -> SMFetcherMessage
    {
        let result: SMFetcherMessagePaging = super.createFetcherMessage() as! SMFetcherMessagePaging
        
        result.pagingOffset = pageOffset
        result.pagingSize = pageSize
        result.reloading = isReloading
        result.loadingMore = isLoadingMore
        
        return result
    }
    
    override func setupModels(_ aModels: [AnyObject], forSection aSection: SMSectionReadonly)
    {
        models.append(contentsOf: aModels)
        
        self.tableDisposer?.setupModels(models, forSection: aSection)
        
        let _ = self.setupMoreCellDataFor(section: aSection, pagedModelsCount: aModels.count)
    }
    
    func setupMoreCellDataFor(section aSection: SMSectionReadonly, pagedModelsCount aPagedModelsCount: Int) -> Bool
    {
        moreCell = nil
        
        if (aPagedModelsCount == self.pageSize && self.pageSize != 0) && (self.pagingDelegate != nil && self.pagingDelegate!.moreCellDataForPaging(moduleList:) != nil)
        {
            let moreCellData: SMPagingMoreCellDataProtocol = self.pagingDelegate!.moreCellDataForPaging!(moduleList: self)
            
            if moreCellData.addTarget(_:action:) != nil
            {
                moreCellData.addTarget!(self, action: #selector(SMModuleListPaging.loadMoreDataPressed))
                aSection.addCellData(moreCellData as! SMCellData)
                
                return true
            }
        }
        
        return false
    }
    
    func loadMoreDataPressed() -> Void
    {
        self.loadMoreData()
    }
/*
     - (BOOL)setupMoreCellDataForSection:(SMSectionReadonly*)section withPagedModelsCount:(NSUInteger)modelsCount
     {
     moreCell = nil;
     if ((modelsCount == self.pageSize && self.pageSize) && section && [self.delegate respondsToSelector:@selector(moreCellDataForPagingModule:)])
     {
     SMCellData<SMPagingMoreCellDataProtocol>* moreCellData = [(id<SMModuleListPagingDelegate>)self.delegate moreCellDataForPagingModule:self];
     if (moreCellData)
     {
     if ([moreCellData respondsToSelector:@selector(addTarget:action:)])
     [moreCellData addTarget:self action:@selector(loadMoreDataPressed:)];
     [section addCellData:moreCellData];
     return YES;
     }
     }
     return NO;
     }
*/
    
    // MARK:
    
    func tableView(_ aTableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
    }
}
