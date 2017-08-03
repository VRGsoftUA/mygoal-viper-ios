//
//  SMNativePullToRefreshAdapterRefreshCallback.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 2/2/17.
//  Copyright © 2017 OnePlanetOps. All rights reserved.
//

import UIKit

class SMNativePullToRefreshAdapter: SMPullToRefreshAdapter
{
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    override var enabled: Bool?
    {
        set {refreshControl.isEnabled = (newValue != nil)}
        get {return refreshControl.isEnabled}
    }
    
    override init()
    {
        super.init()
        
        refreshControl.addTarget(self, action: #selector(refreshControlDidBeginRefreshing(sender:)), for: UIControlEvents.valueChanged)
    }
    
    override func configureWith(scrollView aScrollView: UIScrollView)
    {
        aScrollView.addSubview(refreshControl)
        aScrollView.sendSubview(toBack: refreshControl)
    }
    
    override open func beginPullToRefresh() -> Void
    {
        refreshControl.beginRefreshing()
        super.beginPullToRefresh()
    }
    
    override open func endPullToRefresh() -> Void
    {
        refreshControl.endRefreshing()
    }
    
    @objc func refreshControlDidBeginRefreshing(sender aSender: UIRefreshControl) -> Void
    {
        if refreshControl == aSender
        {
            self.beginPullToRefresh()
        }
    }
}
