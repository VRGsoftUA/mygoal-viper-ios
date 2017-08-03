//
//  SMCreateGoalRouter.swift
//  Project: SMMyGoal
//
//  Module: CreateGoal
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import UIKit

final class SMCreateGoalRouter {
    
	weak var view: UIViewController!
}


extension SMCreateGoalRouter: SMCreateGoalRouterInput {
    
    func goToGoalCategories(presenter: SMGoalCategoriesModuleOutput) {
        
        let goalCategoriesView = SMGoalCategoriesModule.configureWith { () -> (SMGoalCategoriesModuleOutput) in
            return presenter
        }.view
        
        goalCategoriesView.providesPresentationContextTransitionStyle = true
        goalCategoriesView.definesPresentationContext = true
        goalCategoriesView.modalPresentationStyle = .overCurrentContext
        goalCategoriesView.modalTransitionStyle = .crossDissolve
        
        view.present(goalCategoriesView, animated: true, completion: nil)
    }

    func closeCurrentModule() {
        
        let isModal =  (view.navigationController?.childViewControllers[0] == view || view.navigationController == nil)
        
        if isModal {
            view.dismiss(animated: true, completion: nil)
        } else {
            view.navigationController!.popViewController(animated: true)
        }
    }
}
