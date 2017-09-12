//
//  SMMatchGoalModule.swift
//  Project: MyGoal
//
//  Module: MatchGoal
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import UIKit

final class SMMatchGoalModule
{
    private var viewController: SMMatchGoalViewController?
    
    var matchGoalModuleBlock: ((SMMatchGoalModuleInput) -> ())?
    
    var view: UIViewController
    {
        guard let view = viewController else
        {
            viewController = SMMatchGoalViewController(nibName: "SMMatchGoalViewController", bundle: nil)
            self.configureModule(view: viewController!)
            return viewController!
        }
        
        return view
    }
    
    static func configureWith(block: @escaping (SMMatchGoalModuleInput) -> ()) -> SMMatchGoalModule
    {
        let module = SMMatchGoalModule()
        module.matchGoalModuleBlock = block
    
        return module
    }
    
    private func configureModule(view: SMMatchGoalViewController)
    {
        let router = SMMatchGoalRouter()
        router.view = view
        
        let presenter = SMMatchGoalPresenter()
        presenter.view = view
        presenter.router = router
        
        let interactor = SMMatchGoalInteractor()
        interactor.output = presenter
        
        presenter.interactor = interactor
        view.output = presenter
        
        if let block = self.matchGoalModuleBlock
        {
            block(presenter)
        }
    }
}
