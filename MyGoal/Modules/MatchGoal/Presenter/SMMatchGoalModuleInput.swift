//
//  SMMatchGoalModuleInput.swift
//  Project: MyGoal
//
//  Module: MatchGoal
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import Foundation

protocol SMMatchGoalModuleInput: class {
    func configureWith(goal: SMGoal, outputHandler: SMMatchGoalModuleOutput?)
}