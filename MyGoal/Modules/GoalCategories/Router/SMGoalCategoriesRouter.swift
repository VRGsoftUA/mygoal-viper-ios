//
//  SMGoalCategoriesRouter.swift
//  Project: SMMyGoal
//
//  Module: GoalCategories
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import UIKit

final class SMGoalCategoriesRouter {
    
	weak var view: UIViewController!
}


extension SMGoalCategoriesRouter: SMGoalCategoriesRouterInput {
    
    func closeCurrentModule() {
        
        let isModal =  (view.navigationController?.childViewControllers[0] == view || view.navigationController == nil)
        
        if isModal
        {
            view.dismiss(animated: true, completion: nil)
        } else
        {
            view.navigationController!.popViewController(animated: true)
        }
    }
}
