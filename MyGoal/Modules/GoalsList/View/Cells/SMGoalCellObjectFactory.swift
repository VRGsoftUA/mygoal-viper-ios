//
//  SMGoalCellObjectFactory.swift
//  MyGoal
//
//  Created by OLEKSANDR SEMENIUK on 7/31/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

class SMGoalCellObjectFactory: NSObject {
    
    static func cellFor(goal: SMGoal, tableView: UITableView) -> UITableViewCell
    {
        let identifier = String(describing: SMGoalCell.self)
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil
        {
            cell = SMGoalCell.loadFromNib()
        }
        
        let goalCell = (cell as! SMGoalCell)
        
        goalCell.lbHabbit.text = goal.habit
        goalCell.lbProgress.text = "\(goal.progress) %"
        
        let category = SMCategoryType.SMCategory(rawValue: goal.categoryID)
        goalCell.ivIcon.image = UIImage(named: (category?.get().1)!)
        
        return goalCell
    }
}
