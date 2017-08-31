//
//  SMBasePresenter.swift
//  MyGoal
//
//  Created by OLEKSANDR SEMENIUK on 8/29/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

class SMBasePresenter
{
    var router: SMBaseRouter!
    var interactor: SMBaseInteractor!
    weak var view: UIViewController!
    
    required init()
    {
        
    }
}
