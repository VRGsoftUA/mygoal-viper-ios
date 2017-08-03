//
//  UIViewController.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 1/23/17.
//  Copyright © 2017 OnePlanetOps. All rights reserved.
//

import UIKit

extension UIViewController
{
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController?
    {
        if let navigationController = controller as? UINavigationController
        {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController
        {
            if let selected = tabController.selectedViewController
            {
                return topViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController
        {
            return topViewController(controller: presented)
        }
        
        return controller
    }
    
    func sm_showAlertController(title aTitle: String?, message aMessage: String?, cancelButtonTitle aCancelButtonTitle: String?)
    {
        if aTitle == nil && aMessage == nil
        {
            return
        }
        
        self.sm_showAlertController(title: aTitle, message: aMessage, cancelButtonTitle: aCancelButtonTitle, otherButtonTitles: nil, handler: nil)
    }

    func sm_showAlertController(title aTitle: String?,
                                   message aMessage: String?,
                                   cancelButtonTitle aCancelButtonTitle: String? = NSLocalizedString("OK", comment: ""),
                                   otherButtonTitles aOtherButtonTitles: [String]?,
                                   handler aHandler: ((_ aVc: SMAlertController,_ aButtonIndex: Int)  -> Swift.Void)? = nil) -> Void
    {
        SMAlertController.showAlertController(style: UIAlertControllerStyle.alert, title: aTitle, message: aMessage, fromVC: self, otherButtonTitles: aOtherButtonTitles)
    }
    
    func sm_showSheetController(title aTitle: String?,
                                   message aMessage: String?,
                                   cancelButtonTitle aCancelButtonTitle: String? = NSLocalizedString("OK", comment: ""),
                                   otherButtonTitles aOtherButtonTitles: [String]?,
                                   handler aHandler: ((_ aVc: SMAlertController,_ aButtonIndex: Int)  -> Swift.Void)? = nil) -> Void
    {
        SMAlertController.showAlertController(style: UIAlertControllerStyle.alert, title: aTitle, message: aMessage, fromVC: self, otherButtonTitles: aOtherButtonTitles)
    }

}
