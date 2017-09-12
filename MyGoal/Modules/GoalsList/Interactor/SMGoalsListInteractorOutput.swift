//
//  SMGoalsListInteractorOutput.swift
//  Project: MyGoal
//
//  Module: GoalsList
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import Foundation

protocol SMGoalsListInteractorOutput: class
{
    func didObtainTitle(text: String)
    func didObtainGoals(goals: [SMGoal])
}
