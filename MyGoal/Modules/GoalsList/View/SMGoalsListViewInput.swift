//
//  SMGoalsListViewInput.swift
//  Project: MyGoal
//
//  Module: GoalsList
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import Foundation

protocol SMGoalsListViewInput: class
{
    func updateViewWith(title: String)
    func updateViewWith(goals: [SMGoal])
}
