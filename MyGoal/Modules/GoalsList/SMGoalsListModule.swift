//
//  SMGoalsListModule.swift
//  Project: MyGoal
//
//  Module: GoalsList
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import UIKit

final class SMGoalsListModule {
    
    private var navigationController: SMBaseNavigationController?
    
    var view: UIViewController
    {
        guard let view = navigationController else
        {
            let viewController = SMGoalsListViewController()
            navigationController = SMBaseNavigationController(rootViewController: viewController)
            self.configureModule(view: viewController)
            return navigationController!
        }
        
        return view
    }
    
    private func configureModule(view: SMGoalsListViewController)
    {
        
        let router = SMGoalsListRouter()
        router.view = view
        
        let presenter = SMGoalsListPresenter()
        presenter.view = view
        presenter.router = router
        
        let interactor = SMGoalsListInteractor()
        interactor.output = presenter
        
        presenter.interactor = interactor
        view.output = presenter
    }
}
