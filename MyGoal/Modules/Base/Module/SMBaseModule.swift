//
//  SMBaseModule.swift
//  MyGoal
//
//  Created by OLEKSANDR SEMENIUK on 8/29/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

class SMBaseModule
{
    private var viewController: SMBaseViewController?

    var view: SMBaseViewController
    {
        guard let view = viewController else {
            let viewController = self.createViewController()
            self.configureModule(view: viewController)
            return viewController
        }
        return view
    }
    
    func createViewController() -> SMBaseViewController
    {
        let result: SMBaseViewController = self.classViewController().init()
        
        return result
    }
    
    func classViewController() -> SMBaseViewController.Type
    {
        assert(false)
        
        return SMBaseViewController.self
    }

    func classRouter() -> SMBaseRouter.Type
    {
        assert(false)
        
        return SMBaseRouter.self
    }

    func classInteractor() -> SMBaseInteractor.Type
    {
        assert(false)
        
        return SMBaseInteractor.self
    }

    func classPresenter() -> SMBasePresenter.Type
    {
        assert(false)
        
        return SMBasePresenter.self
    }

    func configureModule(view: SMBaseViewController)
    {
        let router = self.classRouter().init()
        router.view = view
        
        let presenter = classPresenter().init()
        presenter.view = view
        presenter.router = router
        
        let interactor = classInteractor().init()
        interactor.output = presenter
        
        presenter.interactor = interactor
        view.output1 = presenter
    }
}
