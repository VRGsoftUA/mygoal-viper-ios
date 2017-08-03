//
//  SMTableDisposerModeled.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 2/2/17.
//  Copyright © 2017 OnePlanetOps. All rights reserved.
//

import UIKit
import MulticastDelegateSwift


@objc protocol SMTableDisposerModeledMulticastDelegate: NSObjectProtocol
{
    @objc optional func tableDisposer(_ aTableDisposer: SMTableDisposer, didCreateCellData aCellData: SMCellData) -> Void
}

@objc protocol SMTableDisposerModeledDelegate: NSObjectProtocol
{
    @objc optional func tableDisposer(_ aTableDisposer: SMTableDisposer, didCreateCellData aCellData: SMCellData) -> Void
    @objc optional func tableDisposer(_ aTableDisposer: SMTableDisposer, cellDataClassForUnregisteredModel aModel: AnyObject) -> AnyClass
}

class SMTableDisposerModeled: SMTableDisposer
{
    let modeledMulticastDelegate: MulticastDelegate<SMTableDisposerModeledMulticastDelegate> = MulticastDelegate(strongReferences: false)

    var registeredClasses : [String: AnyClass] = [:]
    
    weak var modeledDelegate: SMTableDisposerModeledDelegate?
    
    func register(cellDataClass aCellDataClass: AnyClass, forModelClass aModelClass: AnyClass) -> Void
    {
        registeredClasses[String(describing: aModelClass)] = aCellDataClass
    }

    func unregisterCellDataFor(modelClass aModelClass: AnyClass) -> Void
    {
        registeredClasses[String(describing: aModelClass)] = nil
    }

    func setupModels(_ aModels: [AnyObject], forSectionAtIndex aSectionIndex: Int) -> Void
    {
        let section: SMSectionReadonly = self.sections[aSectionIndex]
        self.setupModels(aModels, forSection: section)
    }

    func setupModels(_ aModels: [AnyObject], forSection aSection: SMSectionReadonly) -> Void
    {
        for model in aModels
        {
            let cellData: SMCellDataModeled = self.cellDataFrom(model: model)
            aSection.addCellData(cellData)
            self.didCreate(cellData: cellData)
        }
    }

    func cellDataFrom(model aModel: AnyObject) -> SMCellDataModeled
    {
        let modelClassName: String = String(describing: type(of: aModel))

        var cellDataClass: AnyClass? = registeredClasses[modelClassName]!
        
        if cellDataClass == nil &&
            self.modeledDelegate != nil &&
            self.modeledDelegate!.tableDisposer(_:cellDataClassForUnregisteredModel:) != nil
        {
            cellDataClass = modeledDelegate!.tableDisposer!(self, cellDataClassForUnregisteredModel: aModel)
        }
        
        assert(cellDataClass != nil, String(format: "Model doesn't have registered cellData class %@", modelClassName))
        
        let cellData: SMCellDataModeled = (cellDataClass.self as! SMCellDataModeled.Type).init(model: aModel)
        
        return cellData
    }

    func didCreate(cellData aCellData: SMCellData) -> Void
    {
        if self.modeledDelegate != nil &&
            self.modeledDelegate!.tableDisposer(_:didCreateCellData:) != nil
        {
            self.modeledDelegate!.tableDisposer!(self, didCreateCellData: aCellData)
            
            self.modeledMulticastDelegate.invokeDelegates { (delegate) in
                delegate.tableDisposer!(self, didCreateCellData: aCellData)
            }
        }
    }
}
