//
//  SMBaseNavigationController.swift
//  MyGoal
//
//  Created by OLEKSANDR SEMENIUK on 7/25/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

class SMBaseNavigationController: UINavigationController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let verticalOffset: CGFloat = 0
        
        self.navigationBar.setTitleVerticalPositionAdjustment(verticalOffset, for: UIBarMetrics.default)
        var dic: Dictionary = [String: Any]()
        dic.updateValue(SMUIConfigurator.shared.colors.baseDarkGreen, forKey: NSForegroundColorAttributeName)
        dic.updateValue(UIFont(name: SMUIConfigurator.shared.fonts.bold, size: 20) as Any, forKey: NSFontAttributeName)
        self.navigationBar.titleTextAttributes = dic
        
        self.navigationBar.layer.masksToBounds = false
        self.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.navigationBar.layer.shadowColor = SMUIConfigurator.shared.colors.baseDarkGreen.cgColor
        self.navigationBar.layer.shadowOpacity = 0.3
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .default
    }

}
