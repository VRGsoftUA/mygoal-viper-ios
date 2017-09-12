//
//  SMCreateGoalViewInput.swift
//  Project: MyGoal
//
//  Module: CreateGoal
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import Foundation

protocol SMCreateGoalViewInput: class
{
    func updateViewWith(title: String)
    func updateViewWith(category: SMCategoryType.SMCategory)
}
