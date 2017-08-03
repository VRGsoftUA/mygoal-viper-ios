//
//  SMTableDisposer.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 01/31/17.
//  Copyright © 2016 OnePlanetOps. All rights reserved.
//

import UIKit
import MulticastDelegateSwift


@objc protocol SMTableDisposerDelegate: NSObjectProtocol, UITableViewDelegate, UITableViewDataSource
{
    @objc optional func tableDisposer(_ aTableDisposer: SMTableDisposer, didCreateCell aCell: UITableViewCell)
    @objc optional func tableDisposer(_ aTableDisposer: SMTableDisposer, didSetupCell aCell: UITableViewCell, at aIndexPath: IndexPath)
}

@objc protocol SMTableDisposerMulticastDelegate: NSObjectProtocol
{
    @objc optional func tableDisposer(_ aTableDisposer: SMTableDisposer, didCreateCell aCell: UITableViewCell)

    @objc optional func tableView(_ aTableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
}


class SMTableDisposer: NSObject, UITableViewDelegate, UITableViewDataSource
{
    var tableView: UITableView?
    {
        didSet
        {
            tableView?.delegate = self
            tableView?.dataSource = self
        }
    }
    
    var sections: Array <SMSectionReadonly>! = Array()

    func addSection(_ aSection: SMSectionReadonly) -> Void
    {
        aSection.tableDisposer = self
        sections.append(aSection)
    }
    
    func removeSection(_ aSection: SMSectionReadonly) -> Void
    {
        aSection.tableDisposer = nil
        sections.remove(at: sections.index(of: aSection)!)
    }
    
    var tableClass: AnyClass = UITableView.self
    var tableStyle: UITableViewStyle! = UITableViewStyle.plain
    
    weak var delegate: SMTableDisposerDelegate?
    let multicastDelegate: MulticastDelegate<SMTableDisposerMulticastDelegate> = MulticastDelegate(strongReferences: false)
    
    func didCreate(cell aCell: UITableViewCell)
    {
        if self.delegate != nil && delegate!.tableDisposer(_:didCreateCell:) != nil
        {
            delegate!.tableDisposer!(self, didCreateCell: aCell)
        }
        
        self.multicastDelegate.invokeDelegates { (delegate) in
            delegate.tableDisposer!(self, didCreateCell: aCell)
        }
    }

    func didSetup(cell aCell: UITableViewCell, at aIndexPath: IndexPath)
    {
        if self.delegate != nil && delegate!.tableDisposer(_:didSetupCell:at:) != nil
        {
            delegate!.tableDisposer!(self, didSetupCell: aCell, at: aIndexPath)
        }
    }

    func index(by aSection: SMSectionReadonly) -> Int
    {
        return sections.index(of: aSection)!
    }

    func reloadData() -> Void
    {
        //    if([tableView isKindOfClass:[SMKeyboardAvoidingTableView class]])
        //    {
        //    [((SMKeyboardAvoidingTableView*)tableView) removeAllObjectsForKeyboard];
        //    }

        for section in sections
        {
            section.updateCellDataVisibility()
        }
        
        tableView?.reloadData()
    }
    
    
    // MARK: UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.sections[section].visibleCellDataCount
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let result = self.sections[indexPath.section].cell(forIndex: indexPath.row)
        
        self.didSetup(cell: result, at: indexPath)
        
        return result
    }

    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return sections.count
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return self.sections[section].headerTitle
    }

    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        return self.sections[section].footerTitle
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        var result: Bool = false
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:canEditRowAt:)))
        {
            result = self.delegate!.tableView!(tableView, canEditRowAt: indexPath)
        }
        
        return result
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        var result: Bool = false
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:canMoveRowAt:)))
        {
            result = self.delegate!.tableView!(tableView, canMoveRowAt: indexPath)
        }
        
        return result
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]?
    {
        var result: [String]?
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.sectionIndexTitles))
        {
            result = self.delegate!.sectionIndexTitles!(for: tableView)
        }
        
        return result
    }
    
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
    {
        var result: Int = 0
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:sectionForSectionIndexTitle:at:)))
        {
            result = self.delegate!.tableView!(tableView, sectionForSectionIndexTitle: title, at: index)
        }
        
        return result
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:commit:forRowAt:)))
        {
            self.delegate!.tableView!(tableView, commit: editingStyle, forRowAt: indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:moveRowAt:to:)))
        {
            self.delegate!.tableView!(tableView, moveRowAt: sourceIndexPath, to: destinationIndexPath)
        }
    }
    
    
    // MARK: UITableViewDelegate
    
    // Display customization
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:willDisplay:forRowAt:)))
        {
            self.delegate!.tableView!(tableView, willDisplay: cell, forRowAt: indexPath)
        }
        
        self.multicastDelegate.invokeDelegates { (delegate) in
            delegate.tableView!(tableView, willDisplay: cell, forRowAt: indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:willDisplayHeaderView:forSection:)))
        {
            self.delegate!.tableView!(tableView, willDisplayHeaderView: view, forSection: section)
        }
    }

    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:willDisplayFooterView:forSection:)))
        {
            self.delegate!.tableView!(tableView, willDisplayFooterView: view, forSection: section)
        }
    }

    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:didEndDisplaying:forRowAt:)))
        {
            self.delegate!.tableView!(tableView, didEndDisplaying: cell, forRowAt: indexPath)
        }
    }

    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:didEndDisplayingHeaderView:forSection:)))
        {
            self.delegate!.tableView!(tableView, didEndDisplayingHeaderView: view, forSection: section)
        }
    }

    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:didEndDisplayingFooterView:forSection:)))
        {
            self.delegate!.tableView!(tableView, didEndDisplayingFooterView: view, forSection: section)
        }
    }

    
    // Variable height support
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let cellData: SMCellData = self.sections[indexPath.section].visibleCellDataSource[indexPath.row]
        
        if cellData.cellHeightAutomaticDimension
        {
            return UITableViewAutomaticDimension
        } else
        {
            cellData.cellWidth = tableView.frame.size.width
            return cellData.cellHeightFor(width: tableView.frame.size.width)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let cellData: SMCellData = self.sections[indexPath.section].visibleCellDataSource[indexPath.row]
        cellData.cellWidth = tableView.frame.size.width
        return cellData.cellHeightFor(width: tableView.frame.size.width)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        var result: CGFloat = 0
        
        if self.sections[section].headerView != nil
        {
            result = self.sections[section].headerView!.frame.size.height
            /*[[self sectionByIndex:section].headerTitle length]*/
        } else  if(self.sections[section].headerTitle != nil && (self.sections[section].headerTitle?.characters.count)! > 0)
        {
            result = 20
        }
        
        return result
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        var result: CGFloat = 0
        
        if self.sections[section].footerView != nil
        {
            result = self.sections[section].footerView!.frame.size.height
        } else  if(self.sections[section].footerTitle != nil && (self.sections[section].footerTitle?.characters.count)! > 0)
        {
            result = 20
        }
        
        return result
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return self.sections[section].headerView
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        return self.sections[section].footerView
    }

    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:accessoryButtonTappedForRowWith:)))
        {
            self.delegate!.tableView!(tableView, accessoryButtonTappedForRowWith: indexPath)
        }
    }
    
    
    // Selection
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool
    {
        var result: Bool = true
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:shouldHighlightRowAt:)))
        {
            result = self.delegate!.tableView!(tableView, shouldHighlightRowAt: indexPath)
        }
        
        return result
    }

    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:didHighlightRowAt:)))
        {
            self.delegate!.tableView!(tableView, didHighlightRowAt: indexPath)
        }
    }

    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:didUnhighlightRowAt:)))
        {
            self.delegate!.tableView!(tableView, didUnhighlightRowAt: indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        var result: IndexPath? = indexPath
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:willSelectRowAt:)))
        {
            result = self.delegate!.tableView!(tableView, willSelectRowAt: indexPath)
        }
        
        return result
    }
    
    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath?
    {
        var result: IndexPath? = indexPath
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:willDeselectRowAt:)))
        {
            result = self.delegate!.tableView!(tableView, willDeselectRowAt: indexPath)
        }
        
        return result
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {        
        let cellData: SMCellData = self.sections[indexPath.section].visibleCellData(at: indexPath.row)
        
        cellData.performSelectedHandlers()

        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:didSelectRowAt:)))
        {
            self.delegate!.tableView!(tableView, didSelectRowAt: indexPath)
        }
        
        if cellData.isAutoDeselect
        {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        let cellData: SMCellData = self.sections[indexPath.section].visibleCellData(at: indexPath.row)
        
        cellData.performDeselectedHandlers()
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:didDeselectRowAt:)))
        {
            self.delegate!.tableView!(tableView, didDeselectRowAt: indexPath)
        }
    }

    
    // Editing
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
    {
        var result: UITableViewCellEditingStyle = UITableViewCellEditingStyle.delete
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:editingStyleForRowAt:)))
        {
            result = self.delegate!.tableView!(tableView, editingStyleForRowAt: indexPath)
        }
        
        return result
    }
    
    public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        var result: String? = nil
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:titleForDeleteConfirmationButtonForRowAt:)))
        {
            result = self.delegate!.tableView!(tableView, titleForDeleteConfirmationButtonForRowAt: indexPath)
        }
        
        return result
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        var result: [UITableViewRowAction]? = nil
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:editActionsForRowAt:)))
        {
            result = self.delegate!.tableView!(tableView, editActionsForRowAt: indexPath)
        }
        
        return result
    }

    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool
    {
        var result: Bool = false
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:shouldIndentWhileEditingRowAt:)))
        {
            result = self.delegate!.tableView!(tableView, shouldIndentWhileEditingRowAt: indexPath)
        }
        
        return result
    }
    
    public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:willBeginEditingRowAt:)))
        {
            self.delegate!.tableView!(tableView, willBeginEditingRowAt: indexPath)
        }
    }

    public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:didEndEditingRowAt:)))
        {
            self.delegate!.tableView!(tableView, didEndEditingRowAt: indexPath)
        }
    }

    
    // Moving/reordering
    
    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath
    {
        var result: IndexPath = IndexPath()
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:targetIndexPathForMoveFromRowAt:toProposedIndexPath:)))
        {
            result = self.delegate!.tableView!(tableView, targetIndexPathForMoveFromRowAt: sourceIndexPath, toProposedIndexPath: proposedDestinationIndexPath)
        }
        
        return result
    }


    // Indentation
    
    public func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int
    {
        var result: Int = 0
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:indentationLevelForRowAt:)))
        {
            result = self.delegate!.tableView!(tableView, indentationLevelForRowAt: indexPath)
        }
        
        return result
    }

    
    // Copy/Paste.
    
    public func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool
    {
        var result: Bool = false
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:shouldShowMenuForRowAt:)))
        {
            result = self.delegate!.tableView!(tableView, shouldShowMenuForRowAt: indexPath)
        }
        
        return result
    }
    
    public func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool
    {
        var result: Bool = false
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:canPerformAction:forRowAt:withSender:)))
        {
            result = self.delegate!.tableView!(tableView, canPerformAction: action, forRowAt: indexPath, withSender: sender)
        }
        
        return result
    }
    
    public func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:performAction:forRowAt:withSender:)))
        {
            self.delegate!.tableView!(tableView, performAction: action, forRowAt: indexPath, withSender: sender)
        }
    }

    
    // Focus
    
    @available(iOS 9.0, *)
    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool
    {
        var result: Bool = false
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:canFocusRowAt:)))
        {
            result = self.delegate!.tableView!(tableView, canFocusRowAt: indexPath)
        }
        
        return result
    }

    @available(iOS 9.0, *)
    public func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool
    {
        var result: Bool = false
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:shouldUpdateFocusIn:)))
        {
            result = self.delegate!.tableView!(tableView, shouldUpdateFocusIn: context)
        }
        
        return result
    }

    @available(iOS 9.0, *)
    public func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.tableView(_:didUpdateFocusIn:with:)))
        {
            self.delegate!.tableView!(tableView, didUpdateFocusIn: context, with: coordinator)
        }
    }

    @available(iOS 9.0, *)
    public func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath?
    {
        var result: IndexPath? = nil
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.indexPathForPreferredFocusedView(in:)))
        {
            result = self.delegate!.indexPathForPreferredFocusedView!(in: tableView)
        }
        
        return result
    }
    
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.scrollViewDidScroll(_:)))
        {
            self.delegate!.scrollViewDidScroll!(scrollView)
        }
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) // any zoom scale changes
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.scrollViewDidZoom(_:)))
        {
            self.delegate!.scrollViewDidZoom!(scrollView)
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.scrollViewWillBeginDragging(_:)))
        {
            self.delegate!.scrollViewWillBeginDragging!(scrollView)
        }
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.scrollViewWillEndDragging(_:withVelocity:targetContentOffset:)))
        {
            self.delegate!.scrollViewWillEndDragging!(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.scrollViewDidEndDragging(_:willDecelerate:)))
        {
            self.delegate!.scrollViewDidEndDragging!(scrollView, willDecelerate: decelerate)
        }
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.scrollViewWillBeginDecelerating(_:)))
        {
            self.delegate!.scrollViewWillBeginDecelerating!(scrollView)
        }
    }

    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.scrollViewDidEndDecelerating(_:)))
        {
            self.delegate!.scrollViewDidEndDecelerating!(scrollView)
        }
    }

    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.scrollViewDidEndScrollingAnimation(_:)))
        {
            self.delegate!.scrollViewDidEndScrollingAnimation!(scrollView)
        }
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        var result: UIView? = nil
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.viewForZooming(in:)))
        {
            result = self.delegate!.viewForZooming!(in: scrollView)
        }
        
        return result
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.scrollViewWillBeginZooming(_:with:)))
        {
            self.delegate!.scrollViewWillBeginZooming!(scrollView, with: view)
        }
    }

    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.scrollViewDidEndZooming(_:with:atScale:)))
        {
            self.delegate!.scrollViewDidEndZooming!(scrollView, with: view, atScale: scale)
        }
    }

    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool
    {
        var result: Bool = true
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.scrollViewShouldScrollToTop(_:)))
        {
            result = self.delegate!.scrollViewShouldScrollToTop!(scrollView)
        }
        
        return result
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView)
    {
        if self.delegate != nil && self.delegate!.responds(to: #selector(SMTableDisposerDelegate.scrollViewDidScrollToTop(_:)))
        {
            self.delegate!.scrollViewDidScrollToTop!(scrollView)
        }
    }
}
