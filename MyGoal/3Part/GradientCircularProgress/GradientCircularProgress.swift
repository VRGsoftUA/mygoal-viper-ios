//
//  GradientCircularProgress.swift
//  GradientCircularProgress
//
//  Created by keygx on 2015/07/29.
//  Copyright (c) 2015年 keygx. All rights reserved.
//

import UIKit

internal var baseWindow: BaseWindow?

public class GradientCircularProgress {
    
    var progressView: ProgressView?
    fileprivate var property: Property?
    
    public var isAvailable: Bool = false
    
    public init() {}
}

// MARK: Common
extension GradientCircularProgress {
    
    public func updateMessage(message: String) {
        if !isAvailable {
            return
        }
        
        // Use addSubView
        if let v = progressView {
            v.updateMessage(message)
        }
        
    }
    
    public func updateRatio(_ ratio: CGFloat) {
        if !isAvailable {
            return
        }
        
        // Use addSubView
        if let v = progressView {
            v.ratio = ratio
        }
        
    }
}


// MARK: Use addSubView
extension GradientCircularProgress {
    
    public func showAtRatio(frame: CGRect, display: Bool = true, style: StyleProperty = OrangeClearStyle()) -> UIView? {
        if isAvailable {
            return nil
        }
        isAvailable = true
        property = Property(style: style)
        
        progressView = ProgressView(frame: frame)
        
        guard let v = progressView else {
            return nil
        }
        
        v.arc(display, style: style)
        
        return v
    }
    
    public func show(frame: CGRect, style: StyleProperty = OrangeClearStyle()) -> UIView? {
        if isAvailable {
            return nil
        }
        isAvailable = true
        property = Property(style: style)
        
        return getProgress(frame: frame, message: nil, style: style)
    }
    
    public func show(frame: CGRect, message: String, style: StyleProperty = OrangeClearStyle()) -> UIView? {
        if isAvailable {
            return nil
        }
        isAvailable = true
        property = Property(style: style)
        
        return getProgress(frame: frame, message: message, style: style)
    }
    
    private func getProgress(frame: CGRect, message: String?, style: StyleProperty) -> UIView? {
        
        progressView = ProgressView(frame: frame)
        
        guard let v = progressView else {
            return nil
        }
        
        v.circle(message, style: style)
        
        return v
    }
    
    public func dismiss(progress view: UIView) {
        if !isAvailable {
            return
        }
        
        guard let prop = property else {
            return
        }
        
        cleanup(prop.dismissTimeInterval!, view: view, completionHandler: nil)
    }
    
    public func dismiss(progress view: UIView, completionHandler: @escaping () -> Void) -> () {
        if !isAvailable {
            return
        }
        
        guard let prop = property else {
            return
        }
        
        cleanup(prop.dismissTimeInterval!, view: view) { Void in
            completionHandler()
        }
    }
    
    private func cleanup(_ t: Double, view: UIView, completionHandler: (() -> Void)?) {
        let delay = t * Double(NSEC_PER_SEC)
        let time  = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time) {
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    view.alpha = 0
                },
                completion: { [weak self] finished in
                    view.removeFromSuperview()
                    self?.property = nil
                    self?.isAvailable = false
                    guard let completionHandler = completionHandler else {
                        return
                    }
                    completionHandler()
                }
            )
        }
    }
}
