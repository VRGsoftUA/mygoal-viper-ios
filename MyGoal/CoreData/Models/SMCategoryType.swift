//
//  SMCategoryType.swift
//  mygoal
//
//  Created by OLEKSANDR SEMENIUK on 6/27/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

class SMCategoryType: NSObject {
    
    public enum SMCategory: Int {
        
        case other = 0
        case arts
        case health
        case home
        case money
        case improvement
        case dating
        case social
        case work
        
        func get() -> (String,String) {
            
            var categoryText: String = ""
            var categoryIcon: String = ""
            switch self {
                
            case .arts:
                categoryText = "category_Arts".localized()
                categoryIcon = "icon_arts"
            case .health:
                categoryText = "category_Health_and_fitness".localized()
                categoryIcon = "icon_healthy"
            case .home:
                categoryText = "category_Housekeeping".localized()
                categoryIcon = "icon_home"
            case .money:
                categoryText = "category_Money".localized()
                categoryIcon = "icon_money"
            case .improvement:
                categoryText = "category_Self_improvement".localized()
                categoryIcon = "icon_self_improvement"
            case .dating:
                categoryText = "category_Sex_and_dating".localized()
                categoryIcon = "icon_sex_dating"
            case .social:
                categoryText = "category_Social".localized()
                categoryIcon = "icon_social"
            case .work:
                categoryText = "category_Work_and_study".localized()
                categoryIcon = "icon_work_study"
            default:
                categoryText = "category_Other".localized()
                categoryIcon = "icon_other"
            }
            return (categoryText,categoryIcon)
        }
        
    }
    
    func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
        var i = 0
        return AnyIterator {
                let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
                if next.hashValue != i { return nil }
                i += 1
                return next
        }
    }
    
    func getCategoties() -> ([SMCategory]) {
        var categories = [SMCategory]()
        for item in iterateEnum(SMCategory.self) {
            categories.append(item)
        
        }
        return categories
    }

}
