//
//  SMGoalCategoriesModuleOutput.swift
//  Project: SMMyGoal
//
//  Module: GoalCategories
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import Foundation

protocol  SMGoalCategoriesModuleOutput: class {
    func didSelect(category: SMCategoryType.SMCategory)
}
