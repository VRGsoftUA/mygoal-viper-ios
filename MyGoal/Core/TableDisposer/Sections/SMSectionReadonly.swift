//
//  SMSectionReadonly.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 01/31/17.
//  Copyright © 2016 OnePlanetOps. All rights reserved.
//

import UIKit

class SMSectionReadonly: NSObject
{
    open var cellDataSource: Array <SMCellData>! = Array()
    open var visibleCellDataSource: Array <SMCellData>! = Array()
    open weak var tableDisposer: SMTableDisposer?
    
    open var headerTitle: String?
    open var footerTitle: String?
    open var headerView: UIView?
    open var footerView: UIView?
        
    
    // MARK: CellDatas
    
    func addCellData(_ aCellData: SMCellData) -> Void
    {
        cellDataSource.append(aCellData)
    }
    
    func addCellDataFromArray(_ aCellDatas: Array <SMCellData>) -> Void
    {
        cellDataSource.append(contentsOf: aCellDatas)
    }
    
    func insertCellData(_ aCellData: SMCellData, index aIndex: Int) -> Void
    {
        cellDataSource.insert(aCellData, at: aIndex)
    }

    func removeCellDataAtIndex(_ aIndex: Int) -> Void
    {
        cellDataSource.remove(at: aIndex)
    }

    func removeCellData(_ aCellData: SMCellData) -> Void
    {
        if  let index = cellDataSource.index(of: aCellData)
        {
            cellDataSource.remove(at: index)
        }
    }
    
    func removeAllCellData() -> Void
    {
        cellDataSource.removeAll()
    }

    func cellData(at anIndex: Int) -> SMCellData
    {
        return cellDataSource[anIndex]
    }
    
    func visibleCellData(at anIndex: Int) -> SMCellData
    {
        return visibleCellDataSource[anIndex]
    }
    
    func index(by aCellData: SMCellData) -> Int
    {
        return cellDataSource.index(of: aCellData)!
    }

    func index(byVisible aCellData: SMCellData) -> Int
    {
        return visibleCellDataSource.index(of: aCellData)!
    }
    
    func cellData(byTag aTag: Int) -> SMCellData?
    {
        var result: SMCellData? = nil
        for cd in cellDataSource
        {
            if(cd.tag == aTag)
            {
                result = cd
                break
            }
        }
        
        return result
    }

    var cellDataCount: Int
    {
        get
        {
            return cellDataSource.count
        }
    }

    var visibleCellDataCount: Int
    {
        get
        {
            return visibleCellDataSource.count
        }
    }
    
    func updateCellDataVisibility() -> Void
    {
        visibleCellDataSource.removeAll()
        
        for cd in cellDataSource
        {
            if cd.isVisible
            {
                visibleCellDataSource.append(cd)
            }
        }
    }
    
    
    // MARK: Cells
    
    func cell(forIndex aIndex: Int) -> UITableViewCell
    {
        var cell: UITableViewCell!
        
        var isNewCell: Bool = false
        
        let cellData: SMCellData = self.visibleCellData(at: aIndex)
        cell = tableDisposer!.tableView!.dequeueReusableCell(withIdentifier: cellData.cellIdentifier) as? SMCell
        
        if cell == nil
        {
            isNewCell = true
            cell = cellData.createCell()
        }
        
        (cell as! SMCellProtocol).setupCellData(cellData)
        
        if isNewCell
        {
            tableDisposer!.didCreate(cell: cell!)
        }
        
        return cell
    }
    
    func reload(with anAnimation: UITableViewRowAnimation) -> Void
    {
        self.updateCellDataVisibility()
        tableDisposer!.tableView!.reloadSections(IndexSet(integer:tableDisposer!.index(by: self)), with: anAnimation)
    }
    
    func reloadRows(at aIndexes: Array<Int>, withRowAnimation aRowAnimation: UITableViewRowAnimation) -> Void
    {
        var indexPaths: Array<IndexPath> = Array()
        var indexPath: IndexPath
        
        let sectionIndex: Int = tableDisposer!.index(by: self)
        
        for index: Int in aIndexes
        {
            indexPath = IndexPath(row: index, section: sectionIndex)
            indexPaths.append(indexPath)
        }
        
        tableDisposer!.tableView!.reloadRows(at: indexPaths, with: aRowAnimation)
    }
    
    func deleteRows(at aIndexes: Array<Int>, withRowAnimation aRowAnimation: UITableViewRowAnimation) -> Void
    {
        var toDelete: Array <SMCellData> = Array()
        
        var cellData: SMCellData?
        
        for index: Int in aIndexes
        {
            cellData = self.cellData(at: index)
            toDelete.append(cellData!)
        }
        
        for cd: SMCellData in toDelete
        {
            self.removeCellData(cd)
        }
        
        self.updateCellDataVisibility()
        
        var indexPaths: Array<IndexPath> = Array()
        var indexPath: IndexPath
        
        let sectionIndex: Int = tableDisposer!.index(by: self)
        
        for index: Int in aIndexes
        {
            indexPath = IndexPath(row: index, section: sectionIndex)
            indexPaths.append(indexPath)
        }
        tableDisposer!.tableView!.deleteRows(at: indexPaths, with: aRowAnimation)
    }
    
    
    // MARK: Show/Hide cells
    
    func hideCell(by aIndex: Int, needUpdateTable aNeedUpdateTable: Bool) -> Void
    {
        self.hideCell(by: aIndex, needUpdateTable: aNeedUpdateTable, withRowAnimation: UITableViewRowAnimation.middle)
    }

    func showCell(by aIndex: Int, needUpdateTable aNeedUpdateTable: Bool) -> Void
    {
        self.showCell(by: aIndex, needUpdateTable: aNeedUpdateTable, withRowAnimation: UITableViewRowAnimation.middle)
    }

    func hideCell(by aIndex: Int, needUpdateTable aNeedUpdateTable: Bool, withRowAnimation aRowAnimation: UITableViewRowAnimation) -> Void
    {
        let cellData: SMCellData  = self.cellData(at: aIndex)

        if !cellData.isVisible
        {
            return
        }
        
        let index: Int = self.index(byVisible: cellData)
        
        if  let i = cellDataSource.index(of: cellData)
        {
            cellDataSource.remove(at: i)
        }

        cellData.isVisible = false
        
        if aNeedUpdateTable
        {
            let indexPath: IndexPath = IndexPath(row: index, section: tableDisposer!.index(by: self))
            tableDisposer!.tableView!.deleteRows(at: Array.init(repeating: indexPath, count: 1), with: aRowAnimation)
        }
    }
    
    func showCell(by aIndex: Int, needUpdateTable aNeedUpdateTable: Bool, withRowAnimation aRowAnimation: UITableViewRowAnimation) -> Void
    {
        let cellData: SMCellData  = self.cellData(at: aIndex)
        
        if cellData.isVisible
        {
            return
        }
        
        let index: Int = self.index(byVisible: cellData)
        
        cellData.isVisible = true
        self.updateCellDataVisibility()
        
        if aNeedUpdateTable
        {
            let indexPath: IndexPath = IndexPath(row: index, section: tableDisposer!.index(by: self))
            tableDisposer!.tableView!.insertRows(at: Array.init(repeating: indexPath, count: 1), with: aRowAnimation)
        }
    }
}
