//
//  SMMatchGoalService.swift
//  MyGoal
//
//  Created by OLEKSANDR SEMENIUK on 8/1/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

class SMMatchGoalService: NSObject {
    
    static func updateGoal(plainModel: SMGoal) {
        let model = SMMainStore.shared.objectByID(objID: plainModel.identifier as AnyObject, entity: SMBOGoal.self) as! SMBOGoal
        model.progress = plainModel.progress as NSNumber
        model.notificationTime = plainModel.notificationTime
        model.lastUpdate = plainModel.lastUpdate
        
        SMMainStore.shared.save()
    }
    
    static func checkGoalStatus(goalID: AnyObject) {
        let goal = SMGoalService.getGoalBy(id: goalID)
        
        let controlDate = Calendar.current.date(byAdding: .day, value: 1, to: goal.lastUpdate)
        var order = Calendar.current.compare(controlDate!, to: Date(), toGranularity: .day)
        
        if order == .orderedAscending {
            SMModuleLocalPushes.shared.unsubscribeOnPushNotification(goal: goal)
            SMGoalService.deleteGoal(plainModel: goal)
            self.createAlert(title: "alert_miss_title".localized(), message: "alert_miss_body".localized())
        } else {
            let pushEndDay = Calendar.current.date(byAdding: .day, value: 21, to: goal.createDate)
            order = Calendar.current.compare(Date(), to: pushEndDay!, toGranularity: .day)
            
            if order == .orderedSame {
                SMModuleLocalPushes.shared.unsubscribeOnPushNotification(goal: goal)
                SMGoalService.deleteGoal(plainModel: goal)
                self.createAlert(title: "alert_final_title".localized(), message: "alert_final_body".localized())
            } else {
                let goalView = SMMatchGoalModule.configureWith { (matchGoalModuleInput) in
                    matchGoalModuleInput.configureWith(goal: goal, outputHandler: nil)
                    }.view
                if let nc = UIApplication.shared.keyWindow?.rootViewController as? SMBaseNavigationController {
                    nc.topViewController?.present(goalView, animated: true, completion: nil)
                }
            }
        }
    }
    
    private static func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "alert_action".localized(), style: .default, handler: { (success) in
            
            let createGoalView = SMCreateGoalModule.configureWith { () -> (SMCreateGoalModuleOutput?) in
                return nil
                }.view
            
            createGoalView.providesPresentationContextTransitionStyle = true
            createGoalView.definesPresentationContext = true
            createGoalView.modalPresentationStyle = .fullScreen
            createGoalView.modalTransitionStyle = .crossDissolve
            
            if let nc = UIApplication.shared.keyWindow?.rootViewController as? SMBaseNavigationController {
                nc.topViewController?.present(createGoalView, animated: true, completion: nil)
            }
        }))
        if let nc = UIApplication.shared.keyWindow?.rootViewController as? SMBaseNavigationController {
            nc.topViewController?.present(alert, animated: true, completion: nil)
        }
    }

}
