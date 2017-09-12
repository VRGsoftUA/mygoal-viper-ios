//
//  SMGoalsListViewOutput.swift
//  Project: MyGoal
//
//  Module: GoalsList
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import Foundation

protocol SMGoalsListViewOutput: class
{
	func didLoadView()
    func didReloadView()
    func didSelect(goal: SMGoal)
    func didBtCreateGoalClicked()
}
