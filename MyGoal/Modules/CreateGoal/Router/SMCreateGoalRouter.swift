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
    
	weak var view: SMBaseViewController!
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

    func closeCurrentModule()
    {
        self.view.close()
    }
}
