//
//  SMCreateGoalViewOutput.swift
//  Project: MyGoal
//
//  Module: CreateGoal
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

// MARK: Imports

import Foundation

protocol SMCreateGoalViewOutput: class
{
	func didLoadView()
    func didBtBackClicked()
    func didBtCreateClicked(goal: SMGoal)
    func didBtSelectCategoryClicked()
}
