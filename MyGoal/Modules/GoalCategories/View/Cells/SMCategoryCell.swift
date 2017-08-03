//
//  SMCategoryCell.swift
//  mygoal
//
//  Created by OLEKSANDR SEMENIUK on 6/27/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

class SMCategoryCell: UITableViewCell {
    
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var lbCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .default
        
        self.ivIcon.sm_roundBorder()
        
        self.contentView.backgroundColor = UIColor.clear
        
        self.clean()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.clean()
    }
    
    func clean() -> Void {
        self.lbCategory.text = nil
        self.ivIcon.image = nil
    }
}
