//
//  SMGoalCell.swift
//  mygoal
//
//  Created by OLEKSANDR SEMENIUK on 6/26/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

class SMGoalCell: UITableViewCell {
    
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var lbHabbit: UILabel!
    @IBOutlet weak var lbProgress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.ivIcon.sm_roundBorder()
        self.contentView.backgroundColor = UIColor.clear
        self.clean()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.clean()
    }
    
    func clean() -> Void {
        self.ivIcon.image = nil
        self.lbHabbit.text = nil
        self.lbProgress.text = nil
    }
}

