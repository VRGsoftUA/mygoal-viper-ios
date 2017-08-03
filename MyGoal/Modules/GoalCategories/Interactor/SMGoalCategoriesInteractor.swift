//
//  SMGoalCategoriesInteractor.swift
//  Project: MyGoal
//
//  Module: GoalCategories
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import Foundation

final class SMGoalCategoriesInteractor {
    
	weak var output: SMGoalCategoriesInteractorOutput!
}


extension SMGoalCategoriesInteractor: SMGoalCategoriesInteractorInput {

	func obtainTitle() {
		output.didObtainTitle(text: "GoalCategories")
	}
    
    func obtainCategories() {
        output.didObtainCategories(categories: SMCategoryType().getCategoties())
    }
}
