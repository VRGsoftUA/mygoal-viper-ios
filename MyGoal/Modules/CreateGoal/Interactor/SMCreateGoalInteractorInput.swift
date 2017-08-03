//
//  SMCreateGoalInteractorInput.swift
//  Project: MyGoal
//
//  Module: CreateGoal
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import Foundation

protocol SMCreateGoalInteractorInput: class {
	func obtainTitle()
    func save(goal: SMGoal)
}
