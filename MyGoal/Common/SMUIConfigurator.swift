//
//  SMUIConfigurator.swift
//  mygoal
//
//  Created by OLEKSANDR SEMENIUK on 6/21/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit
import VRGSoftSwiftIOSKit

class SMUIConfigurator: AnyObject {
    
    static let shared = SMUIConfigurator()

    let colors: BaseColors = BaseColors()
    public struct BaseColors {
        public let baseSeparator = UIColorFromRGB(rgbValue: 0xEDEDED)
        public let baseDarkGreen = UIColorFromRGB(rgbValue: 0x025B4D)
    }

    let fonts: BaseFont = BaseFont()
    public struct BaseFont {
        public let bold: String = "Helvetica-Bold"
        public let regular: String = "Helvetica-Light"
        public let medium: String = "Helvetica"
    }

    func navButton() -> UIButton {
        let result: UIButton! = UIButton(type: UIButtonType.system)
        result.backgroundColor = UIColor.clear
        
        return result
    }
    
    func prepareShadowFor(button aButton: UIButton, shadowWith aWidth: CGFloat, shadowHeight aHeight: CGFloat) -> Void {
        aButton.layer.shadowColor = UIColorFromRGB(rgbValue: 0x0000003d).cgColor
        aButton.layer.shadowOffset = CGSize(width: aWidth, height: aHeight)
        aButton.layer.shadowOpacity = 0.7
        aButton.layer.shadowRadius = 1.5
        aButton.layer.cornerRadius = 5
    }
}
