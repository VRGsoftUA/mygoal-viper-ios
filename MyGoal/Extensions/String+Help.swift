//
//  String+Help.swift
//  mygoal
//
//  Created by OLEKSANDR SEMENIUK on 7/19/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
