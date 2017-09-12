//
//  SMGoalsListRouterInput.swift
//  Project: SMMyGoal
//
//  Module: GoalsList
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import Foundation

protocol SMGoalsListRouterInput: class
{
    func goToCreateGoal(presenter: SMCreateGoalModuleOutput)
    func goToGoal(goal: SMGoal, presenter: SMMatchGoalModuleOutput)
}
