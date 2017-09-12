//
//  SMGoalService.swift
//  MyGoal
//
//  Created by OLEKSANDR SEMENIUK on 7/26/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

class SMGoalService: NSObject {
    
    static func createNewGoal(plainModel: SMGoal)
    {
        let model = SMMainStore.shared.object(ofClass: SMBOGoal.self, entityName: SMBOGoal.entityName()) as! SMBOGoal
        
        model.categoryID = plainModel.categoryID as NSNumber
        model.createDate = plainModel.createDate
        model.habit = plainModel.habit
        model.identifier = plainModel.identifier as NSNumber
        model.lastUpdate = plainModel.lastUpdate
        model.notificationTime = plainModel.notificationTime
        model.progress = plainModel.progress as NSNumber
        model.question = plainModel.question
        
        SMMainStore.shared.save()
    }
    
    static func deleteGoal(plainModel: SMGoal)
    {
        let model = SMMainStore.shared.objectByID(objID: plainModel.identifier as AnyObject, entity: SMBOGoal.self)
        
        SMMainStore.shared.remove(object: model)
        SMMainStore.shared.save()
    }
    
    static func getAllGoals() -> [SMGoal]
    {
        var result = [SMGoal]()
        
        if let models = SMMainStore.shared.allObjects(entityName: String(describing: SMBOGoal.self)) as? [SMBOGoal]
        {
            result = self.convertToPlain(models: models)
        }
        
        return result
    }
    
    static func getGoalBy(id: AnyObject) -> SMGoal
    {
        let model = SMMainStore.shared.objectByID(objID: id, entity: SMBOGoal.self)
        
        return self.convertToPlain(models: [model as! SMBOGoal]).first!
    }

    static func convertToPlain(models: [SMBOGoal]) -> [SMGoal]
    {
        var result = [SMGoal]()
        
        for model in models
        {
            let plainModel = SMGoal(categoryID: (model.categoryID?.intValue)!, createDate: model.createDate!, habit: model.habit!, identifier: (model.identifier?.intValue)!, lastUpdate: model.lastUpdate!, notificationTime: model.notificationTime!, progress: (model.progress?.intValue)!, question: model.question!)
            result.append(plainModel)
        }
        
        return result
    }
}
