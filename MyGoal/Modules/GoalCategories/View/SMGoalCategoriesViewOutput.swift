//
//  SMGoalCategoriesViewOutput.swift
//  Project: MyGoal
//
//  Module: GoalCategories
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

// MARK: Imports

import Foundation

protocol SMGoalCategoriesViewOutput: class {
	func didLoadView()
    func didSelect(category: SMCategoryType.SMCategory)
}
