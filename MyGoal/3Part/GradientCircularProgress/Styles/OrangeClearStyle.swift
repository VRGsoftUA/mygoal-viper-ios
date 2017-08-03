//
//  OrangeClearStyle.swift
//  GradientCircularProgress
//
//  Created by keygx on 2015/11/24.
//  Copyright (c) 2015年 keygx. All rights reserved.
//
import UIKit

public struct OrangeClearStyle: StyleProperty {
    // Progress Size
    public var progressSize: CGFloat = 90
    
    // Gradient Circular
    public var arcLineWidth: CGFloat = 13.0
    public var startArcColor: UIColor = .orange
    public var endArcColor: UIColor = .orange
    
    // Base Circular
    public var baseLineWidth: CGFloat? = nil
    public var baseArcColor: UIColor? = nil
    
    // Ratio
    public var ratioLabelFont: UIFont? = UIFont(name: SMUIConfigurator.shared.fonts.medium, size: 15.0)
    public var ratioLabelFontColor: UIColor? = .orange
    
    // Message
    public var messageLabelFont: UIFont? = nil
    public var messageLabelFontColor: UIColor? = nil
    
    // Background
    public var backgroundStyle: BackgroundStyles = .none
    
    // Dismiss
    public var dismissTimeInterval: Double? = nil // 'nil' for default setting.
    
    public init() {}
}
