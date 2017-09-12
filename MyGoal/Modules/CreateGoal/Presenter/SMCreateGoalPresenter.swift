//
//  SMCreateGoalPresenter.swift
//  Project: MyGoal
//
//  Module: CreateGoal
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import UIKit

final class SMCreateGoalPresenter
{
	var router: SMCreateGoalRouterInput!
	var interactor: SMCreateGoalInteractorInput!
	weak var view: SMCreateGoalViewInput!
    
    weak var outputHandler: SMCreateGoalModuleOutput?
    
    fileprivate var moduleState: SMCreateGoalState = SMCreateGoalState()
}

extension SMCreateGoalPresenter: SMCreateGoalViewOutput
{
    
    func didBtSelectCategoryClicked()
    {
        router.goToGoalCategories(presenter: self)
    }

    func didBtCreateClicked(goal: SMGoal)
    {
        goal.categoryID = moduleState.selectedCategory?.rawValue ?? 0
        interactor.save(goal: goal)
        outputHandler?.didCreateGoal()
        router.closeCurrentModule()
    }

	func didLoadView()
    {
		interactor.obtainTitle()
	}
    
    func didBtBackClicked()
    {
        router.closeCurrentModule()
    }
}

extension SMCreateGoalPresenter: SMCreateGoalInteractorOutput
{
	func didObtainTitle(text: String)
    {
        view.updateViewWith(title: text)
	}
}

extension SMCreateGoalPresenter: SMGoalCategoriesModuleOutput
{
    func didSelect(category: SMCategoryType.SMCategory)
    {
        moduleState.selectedCategory = category
        view.updateViewWith(category: category)
    }
}

fileprivate class SMCreateGoalState
{
    var selectedCategory: SMCategoryType.SMCategory?
}
