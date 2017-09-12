//
//  SMGoalsListRouter.swift
//  Project: SMMyGoal
//
//  Module: GoalsList
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import UIKit

final class SMGoalsListRouter
{
	weak var view: UIViewController!
}


extension SMGoalsListRouter: SMGoalsListRouterInput
{
    func goToGoal(goal: SMGoal, presenter: SMMatchGoalModuleOutput)
    {
        SMMatchGoalService.checkGoalStatus(goalID: goal.identifier as AnyObject)
    }

    func goToCreateGoal(presenter: SMCreateGoalModuleOutput)
    {
        let createGoalView = SMCreateGoalModule.configureWith { () -> (SMCreateGoalModuleOutput) in
            return presenter
        }.view
        
        createGoalView.providesPresentationContextTransitionStyle = true
        createGoalView.definesPresentationContext = true
        createGoalView.modalPresentationStyle = .fullScreen
        createGoalView.modalTransitionStyle = .crossDissolve
        
        view.present(createGoalView, animated: true, completion: nil)
    }
}
