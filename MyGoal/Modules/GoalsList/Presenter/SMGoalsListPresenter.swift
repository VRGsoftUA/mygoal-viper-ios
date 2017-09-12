//
//  SMGoalsListPresenter.swift
//  Project: MyGoal
//
//  Module: GoalsList
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import UIKit

final class SMGoalsListPresenter
{
	var router: SMGoalsListRouterInput!
	var interactor: SMGoalsListInteractorInput!
	weak var view: SMGoalsListViewInput!
}

extension SMGoalsListPresenter: SMGoalsListViewOutput
{
    func didBtCreateGoalClicked()
    {
        router.goToCreateGoal(presenter: self)
    }

    func didSelect(goal: SMGoal)
    {
        router.goToGoal(goal: goal, presenter: self)
    }

	func didLoadView()
    {
		interactor.obtainTitle()
        interactor.obtainGoals()
	}
    
    func didReloadView()
    {
        interactor.obtainGoals()
    }
}

extension SMGoalsListPresenter: SMGoalsListInteractorOutput
{
	func didObtainTitle(text: String)
    {
        view.updateViewWith(title: text)
	}
    
    func didObtainGoals(goals: [SMGoal])
    {
        view.updateViewWith(goals: goals)
    }
}

extension SMGoalsListPresenter: SMMatchGoalModuleOutput
{
    func didMatchGoal()
    {
        interactor.obtainGoals()
    }
}

extension SMGoalsListPresenter: SMCreateGoalModuleOutput
{
    func didCreateGoal()
    {
        interactor.obtainGoals()
    }
}
