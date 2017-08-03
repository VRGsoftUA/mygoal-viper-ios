//
//  SMUserNotificationDelegate.swift
//  mygoal
//
//  Created by OLEKSANDR SEMENIUK on 7/14/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit
import UserNotifications

class SMUserNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        SMMatchGoalService.checkGoalStatus(goalID: response.notification.request.content.userInfo["id"] as AnyObject)
        completionHandler()
    }
}
