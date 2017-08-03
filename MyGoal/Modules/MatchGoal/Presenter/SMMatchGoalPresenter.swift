//
//  SMMatchGoalPresenter.swift
//  Project: MyGoal
//
//  Module: MatchGoal
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import UIKit

final class SMMatchGoalPresenter {
    
	var router: SMMatchGoalRouterInput!
	var interactor: SMMatchGoalInteractorInput!
	weak var view: SMMatchGoalViewInput!
    
    weak var outputHandler: SMMatchGoalModuleOutput?
    
    fileprivate var moduleState: SMMatchGoalState = SMMatchGoalState()
}

extension SMMatchGoalPresenter: SMMatchGoalViewOutput {

	func didLoadView() {
		interactor.obtainTitle()
	}
    
    func didBtBackClicked() {
        router.closeCurrentModule()
    }
    
    func didBtYesClicked(goal: SMGoal) {
        interactor.updateGoal(goal: goal)
        moduleState.goal = goal
    }
    
    func didPushTimeUpdated(goal: SMGoal) {
        interactor.updatePushTime(goal: goal)
    }
}

extension SMMatchGoalPresenter: SMMatchGoalInteractorOutput {
    
	func didObtainTitle(text: String) {
        view.updateViewWith(title: text)
	}
    
    func didUpdate(goal: SMGoal) {
        outputHandler?.didMatchGoal()
        router.closeCurrentModule()
    }
}

extension SMMatchGoalPresenter: SMMatchGoalModuleInput {
    func configureWith(goal: SMGoal, outputHandler: SMMatchGoalModuleOutput?) {
        moduleState.goal = goal
        self.outputHandler = outputHandler
        view.updateViewWith(goal: goal)
    }
}

fileprivate class SMMatchGoalState {
    var goal: SMGoal?
}
