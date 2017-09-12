//
//  SMCreateGoalRouterInput.swift
//  Project: SMMyGoal
//
//  Module: CreateGoal
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import Foundation

protocol SMCreateGoalRouterInput: class
{
    func closeCurrentModule()
    func goToGoalCategories(presenter: SMGoalCategoriesModuleOutput)
}
