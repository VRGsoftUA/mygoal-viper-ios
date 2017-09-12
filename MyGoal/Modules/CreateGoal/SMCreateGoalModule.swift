//
//  SMCreateGoalModule.swift
//  Project: MyGoal
//
//  Module: CreateGoal
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import UIKit

final class SMCreateGoalModule
{    
    private var viewController: SMCreateGoalViewController?
    
    var createGoalModuleBlock: (() -> (SMCreateGoalModuleOutput?))?
    
    var view: UIViewController
    {
        guard let view = viewController else
        {
            viewController = SMCreateGoalViewController()
            self.configureModule(view: viewController!)
            return viewController!
        }
        
        return view
    }
    
    static func configureWith(block: @escaping () -> (SMCreateGoalModuleOutput?)) -> SMCreateGoalModule
    {
        let module = SMCreateGoalModule()
        module.createGoalModuleBlock = block
    
        return module
    }

    
    private func configureModule(view: SMCreateGoalViewController)
    {
        let router = SMCreateGoalRouter()
        router.view = view
        
        let presenter = SMCreateGoalPresenter()
        presenter.view = view
        presenter.router = router
        
        let interactor = SMCreateGoalInteractor()
        interactor.output = presenter
        
        presenter.interactor = interactor
        view.output = presenter
        
        if let block = createGoalModuleBlock
        {
            presenter.outputHandler = block()
        }
    }
}
