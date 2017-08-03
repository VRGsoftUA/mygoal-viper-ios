//
//  SMMatchGoalInteractorInput.swift
//  Project: MyGoal
//
//  Module: MatchGoal
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import Foundation

protocol SMMatchGoalInteractorInput: class {
	func obtainTitle()
    func updateGoal(goal: SMGoal)
    func updatePushTime(goal: SMGoal)
}
