//
//  SMCreateGoalInteractor.swift
//  Project: MyGoal
//
//  Module: CreateGoal
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import Foundation

final class SMCreateGoalInteractor {
    
	weak var output: SMCreateGoalInteractorOutput!
}


extension SMCreateGoalInteractor: SMCreateGoalInteractorInput {

	func obtainTitle() {
		output.didObtainTitle(text: "create_goal_title".localized())
	}
    
    func save(goal: SMGoal) {
        SMGoalService.createNewGoal(plainModel: goal)
        SMModuleLocalPushes.shared.subscribeOnPushNotification(subtitle: "push_title".localized(), For: goal)
    }
}
