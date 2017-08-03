//
//  SMCellData.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 01/31/17.
//  Copyright © 2016 OnePlanetOps. All rights reserved.
//

import UIKit

class SMCellData: NSObject
{
    var cellSelectedHandlers: Array <SMBlockAction>! = Array()
    var cellDeselectedHandlers: Array <SMBlockAction>! = Array()
    
    var cellNibName: String?
    var cellClass: AnyClass?
    var cellIdentifier: String
    {
        get {return String(describing: type(of: self))}
    }
    
    var cellStyle: UITableViewCellStyle! = UITableViewCellStyle.default

    var cellSelectionStyle: UITableViewCellSelectionStyle! = UITableViewCellSelectionStyle.default
    var cellAccessoryType: UITableViewCellAccessoryType! = UITableViewCellAccessoryType.none
    
    var isAutoDeselect: Bool = true
    var isVisible: Bool = true
    var isEnableEdit: Bool = true
    var isDisableInputTraits: Bool = false
    var tag: Int = 0
    var userData: Dictionary <NSObject, String>? = nil
    
    var cellHeightAutomaticDimension = false
    
    var cellHeight: CGFloat = 44.0
    var cellWidth: CGFloat = 0.0

    func cellHeightFor(width aWidth: CGFloat) -> CGFloat
    {
        return self.cellHeight
    }
    
    
    // MARK: Handlers
    
    func addCellSelected(blockAction aBlockAction:@escaping SMBlockActionBlock) -> Void
    {
        cellSelectedHandlers.append(SMBlockAction(block: aBlockAction))
    }
    
    func addCellDeselected(blockAction aBlockAction:@escaping SMBlockActionBlock) -> Void
    {
        cellDeselectedHandlers.append(SMBlockAction(block: aBlockAction))
    }

    func performSelectedHandlers() -> Void
    {
        for handler in cellSelectedHandlers
        {
            handler.performBlockFrom(sender: self)
        }
    }

    func performDeselectedHandlers() -> Void
    {
        for handler in cellDeselectedHandlers
        {
            handler.performBlockFrom(sender: self)
        }
    }


    // MARK: Create cell
    
    func createCell() -> UITableViewCell
    {
        var cell: UITableViewCell? = nil
        if (cellNibName != nil)
        {
            cell = (Bundle.main.loadNibNamed(cellNibName!, owner: self, options: nil)?.last! as! SMCell)
        }
        else
        {
            let cellClass = self.cellClass.self as! UITableViewCell.Type
            cell = cellClass.init(style: self.cellStyle, reuseIdentifier: self.cellIdentifier)
        }
        return cell!
    }}
