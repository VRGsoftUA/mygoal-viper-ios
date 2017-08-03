//
//  SMModuleLocalPushes.swift
//  mygoal
//
//  Created by OLEKSANDR SEMENIUK on 7/14/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit
import UserNotifications

class SMModuleLocalPushes: NSObject {
    
    static let shared = SMModuleLocalPushes()
    
    func subscribeOnPushNotification(subtitle aSubtitle: String, For goal: SMGoal) {
        
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            
            if settings.authorizationStatus == .authorized {
                let content = UNMutableNotificationContent()
                content.title = "common_App_name".localized()
                content.body = aSubtitle
                content.sound = UNNotificationSound.default()
                content.userInfo.updateValue(goal.identifier, forKey: "id")
                
                let triggerDaily = Calendar.current.dateComponents([.hour,.minute], from: goal.notificationTime)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
                
                let identifier = "SMLocalNotification\(goal.identifier)"
                
                let request = UNNotificationRequest(identifier: identifier,
                                                    content: content, trigger: trigger)
                center.add(request, withCompletionHandler: { (error) in
                    if error != nil {
                        print("Something went wrong")
                    }
                })
            }
        }
    }
    
    func unsubscribeOnPushNotification(goal: SMGoal) {
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: ["SMLocalNotification\(goal.identifier)"])
        center.removePendingNotificationRequests(withIdentifiers: ["SMLocalNotification\(goal.identifier)"])
    }

}
