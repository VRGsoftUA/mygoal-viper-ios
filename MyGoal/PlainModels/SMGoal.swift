//
//  SMGoal.swift
//  MyGoal
//
//  Created by OLEKSANDR SEMENIUK on 7/26/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

class SMGoal: NSObject {
    
    var categoryID: Int
    var createDate: Date
    var habit: String
    var identifier: Int
    var lastUpdate: Date
    var notificationTime: Date
    var progress: Int
    var question: String?
    
    init(categoryID: Int, createDate: Date, habit: String, identifier: Int, lastUpdate: Date, notificationTime: Date, progress: Int, question: String?) {
        self.categoryID = categoryID
        self.createDate = createDate
        self.habit = habit
        self.identifier = identifier
        self.lastUpdate = lastUpdate
        self.notificationTime = notificationTime
        self.progress = progress
        self.question = question
        super.init()
    }

}
