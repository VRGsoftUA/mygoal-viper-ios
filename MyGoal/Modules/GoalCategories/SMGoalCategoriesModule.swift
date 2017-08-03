//
//  SMGoalCategoriesModule.swift
//  Project: MyGoal
//
//  Module: GoalCategories
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import UIKit

final class SMGoalCategoriesModule {
    
    private var viewController: SMGoalCategoriesViewController?
    var goalCategoriesModuleBlock: (() -> (SMGoalCategoriesModuleOutput))?
    
    var view: UIViewController {
        guard let view = viewController else {
            viewController = SMGoalCategoriesViewController(nibName: "SMGoalCategoriesViewController", bundle: nil)
            self.configureModule(view: viewController!)
            return viewController!
        }
        return view
    }
    
    static func configureWith(block: @escaping () -> (SMGoalCategoriesModuleOutput)) -> SMGoalCategoriesModule
    {
        let module = SMGoalCategoriesModule()
        module.goalCategoriesModuleBlock = block
        return module
    }
    
    private func configureModule(view: SMGoalCategoriesViewController)
    {
        let router = SMGoalCategoriesRouter()
        router.view = view
        
        let presenter = SMGoalCategoriesPresenter()
        presenter.view = view
        presenter.router = router
        
        let interactor = SMGoalCategoriesInteractor()
        interactor.output = presenter
        
        presenter.interactor = interactor
        view.output = presenter
        
        if let block = goalCategoriesModuleBlock
        {
            presenter.outputHandler = block()
        }
    }
}
