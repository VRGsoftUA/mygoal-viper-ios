//
//  SMModuleRemotePushes.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 1/30/17.
//  Copyright © 2017 OnePlanetOps. All rights reserved.
//

import UIKit

class SMModuleRemotePushes
{
    var deviceToken: String?
    
    open func tryToRegisterForUserNotificationDefault() -> Void
    {
        //self.tryToRegisterFor(userNotificationTypes: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound])
    }

//    open func tryToRegisterFor(userNotificationTypes aUserNotificationTypes: UIUserNotificationType) -> Void
//    {
//        let notificationSettings: UIUserNotificationSettings = UIUserNotificationSettings(types: aUserNotificationTypes, categories: nil)
//        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
//    }

    open func didRegisterForRemoteNotificationsWith(deviceTokenData aDeviceTokenData: Data) -> Void
    {
        var token: String = ""
        for i in 0..<aDeviceTokenData.count
        {
            token += String(format: "%02.2hhx", aDeviceTokenData[i] as CVarArg)
        }
        
        deviceToken = token
        
        if deviceToken != nil
        {
            self.registerForPushNotifications()
        }
    }
    
    open func registerForPushNotifications() -> Void
    {
        if self.deviceToken != nil && self.canRegisterDeviceToken()
        {
            self.registerDeviceTokenRequest()?.start()
        }
    }

    open func unregisterForPushNotifications() -> Void
    {
        if self.deviceToken != nil && self.canUnregisterDeviceToken()
        {
            self.unregisterDeviceTokenRequest()?.start()
        }
    }

    open func registerDeviceTokenRequest() -> SMRequest?
    {
        return nil
    }

    open func unregisterDeviceTokenRequest() -> SMRequest?
    {
        return nil
    }

    open func canRegisterDeviceToken() -> Bool
    {
        return true
    }
    
    open func canUnregisterDeviceToken() -> Bool
    {
        return true
    }
}
