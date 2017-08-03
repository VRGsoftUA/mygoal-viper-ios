//
//  SMCell.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 01/31/17.
//  Copyright © 2016 OnePlanetOps. All rights reserved.
//

import UIKit


class SMCell: UITableViewCell, SMCellProtocol
{
    required override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.clear
    }
    
    func inputTraits() -> Array <AnyObject>?
    {
        return nil
    }
    
    override var reuseIdentifier: String
    {
        get { return self.cellData!.cellIdentifier }
    }

    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
    
    // MARK: SMCellProtocol
    
    var cellData: SMCellData? = nil
    func setupCellData(_ aCellData: SMCellData!) -> Void
    {
        if cellData != aCellData
        {
            cellData = aCellData
        }
        
        if aCellData.cellWidth > 0
        {
            var frame = self.frame
            frame.size.width = aCellData.cellWidth
            self.frame = frame
            
            if (self.superview == nil)
            {
                self.contentView.frame = self.bounds
            }
        }
        
        self.selectionStyle = aCellData.cellSelectionStyle
        self.accessoryType = aCellData.cellAccessoryType
        self.tag = aCellData.tag
    }
}
