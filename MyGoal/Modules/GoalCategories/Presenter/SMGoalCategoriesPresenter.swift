//
//  SMGoalCategoriesPresenter.swift
//  Project: MyGoal
//
//  Module: GoalCategories
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import UIKit

final class SMGoalCategoriesPresenter {

	var router: SMGoalCategoriesRouterInput!
	var interactor: SMGoalCategoriesInteractorInput!
	weak var view: SMGoalCategoriesViewInput!
    
    weak var outputHandler: SMGoalCategoriesModuleOutput?
    
    fileprivate var moduleState: SMGoalCategoriesState = SMGoalCategoriesState()
}

extension SMGoalCategoriesPresenter: SMGoalCategoriesViewOutput {
    
    func didSelect(category: SMCategoryType.SMCategory) {
        outputHandler?.didSelect(category: category)
        router.closeCurrentModule()
    }
    
	func didLoadView() {
		interactor.obtainTitle()
        interactor.obtainCategories()
	}
}

extension SMGoalCategoriesPresenter: SMGoalCategoriesInteractorOutput {

	func didObtainTitle(text: String) {
        view.updateViewWith(title: text)
	}
    
    func didObtainCategories(categories: [SMCategoryType.SMCategory]) {
        view.updateViewWith(categories: categories)
    }
}

extension SMGoalCategoriesPresenter: SMGoalCategoriesModuleInput {
    
}

fileprivate class SMGoalCategoriesState {

}
