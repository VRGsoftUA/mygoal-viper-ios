//
//  SMAppDelegate.swift
//  MyGoal
//
//  Created by OLEKSANDR SEMENIUK on 7/25/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit
import UserNotifications
import Fabric
import Crashlytics


@UIApplicationMain
class SMAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let pushDelegate = SMUserNotificationDelegate()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController =  SMGoalsListModule().view
        self.window?.makeKeyAndVisible()
        
        //Notifications
        let center = UNUserNotificationCenter.current()
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        
        center.delegate = pushDelegate
        
        Fabric.with([Crashlytics.self])

        
        return true
    }
}

