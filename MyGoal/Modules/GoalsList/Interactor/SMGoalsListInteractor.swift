//
//  SMGoalsListInteractor.swift
//  Project: MyGoal
//
//  Module: GoalsList
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import Foundation

final class SMGoalsListInteractor
{
	weak var output: SMGoalsListInteractorOutput!
}

extension SMGoalsListInteractor: SMGoalsListInteractorInput
{
	func obtainTitle()
    {
		output.didObtainTitle(text: "goals_list_title".localized())
	}
    
    func obtainGoals()
    {
        output.didObtainGoals(goals: SMGoalService.getAllGoals())
    }
}
