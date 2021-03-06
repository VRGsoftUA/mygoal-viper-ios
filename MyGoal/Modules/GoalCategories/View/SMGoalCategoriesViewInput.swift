//
//  SMGoalCategoriesViewInput.swift
//  Project: MyGoal
//
//  Module: GoalCategories
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import Foundation

protocol SMGoalCategoriesViewInput: class {
    func updateViewWith(title: String)
    func updateViewWith(categories: [SMCategoryType.SMCategory])
}
