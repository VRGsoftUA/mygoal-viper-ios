//
//  SMMatchGoalInteractor.swift
//  Project: MyGoal
//
//  Module: MatchGoal
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import Foundation

final class SMMatchGoalInteractor {
    
	weak var output: SMMatchGoalInteractorOutput!
}


extension SMMatchGoalInteractor: SMMatchGoalInteractorInput {
    
	func obtainTitle() {
		output.didObtainTitle(text: "check_goal_title".localized())
	}
    
    func updateGoal(goal: SMGoal) {
        let isGoalUpdateable = Calendar.current.compare(Date(), to: goal.lastUpdate, toGranularity: .day)
        let isFirstUpdate = Calendar.current.compare(Date(), to: goal.createDate, toGranularity: .day)
        let isFirstUpdateAvailable = Calendar.current.compare(Date(), to: goal.notificationTime, toGranularity: .minute)
        
        if isGoalUpdateable == .orderedDescending || (isFirstUpdate == .orderedSame && goal.progress == 0 && (isFirstUpdateAvailable == .orderedDescending || isFirstUpdateAvailable == .orderedSame)) {
            var amount = goal.progress
            if amount < 20 {
                amount += 4
                
            } else if amount >= 20 && amount < 96 {
                amount += 5
            }
            goal.progress = amount
            goal.lastUpdate = Date()
        }
        SMMatchGoalService.updateGoal(plainModel: goal)
        output.didUpdate(goal: goal)
    }
    
    func updatePushTime(goal: SMGoal) {
        SMModuleLocalPushes.shared.subscribeOnPushNotification(subtitle: "push_title".localized(), For: goal)
    }
}
