//
//  SMCategoryCellObjectFactory.swift
//  MyGoal
//
//  Created by OLEKSANDR SEMENIUK on 8/1/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

class SMCategoryCellObjectFactory: NSObject {
    
    static func cellFor(category: SMCategoryType.SMCategory, tableView: UITableView) -> UITableViewCell {
        let identifier = String(describing: SMCategoryCell.self)
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = Bundle.main.loadNibNamed(String(describing: SMCategoryCell.self), owner:nil, options: nil)?.last as? UITableViewCell
        }
        
        let categoryCell = (cell as! SMCategoryCell)
        
        categoryCell.lbCategory.text = category.get().0
        categoryCell.ivIcon.image = UIImage(named: category.get().1)
        
        return categoryCell
    }

}
