//
//  SMGoalCategoriesInteractorOutput.swift
//  Project: MyGoal
//
//  Module: GoalCategories
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import Foundation

protocol SMGoalCategoriesInteractorOutput: class {
    func didObtainTitle(text: String)
    func didObtainCategories(categories: [SMCategoryType.SMCategory])
}
