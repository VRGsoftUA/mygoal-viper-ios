//
//  SMMatchGoalViewOutput.swift
//  Project: MyGoal
//
//  Module: MatchGoal
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import Foundation

protocol SMMatchGoalViewOutput: class {
	func didLoadView()
    func didBtBackClicked()
    func didBtYesClicked(goal: SMGoal)
    func didPushTimeUpdated(goal: SMGoal)
}
