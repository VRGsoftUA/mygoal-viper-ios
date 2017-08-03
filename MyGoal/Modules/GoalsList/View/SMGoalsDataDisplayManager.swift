//
//  SMGoalsDataDisplayManager.swift
//  MyGoal
//
//  Created by OLEKSANDR SEMENIUK on 7/31/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

class SMGoalsDataDisplayManager: NSObject {
    
    var goals: [SMGoal] = []
    var tableView: UITableView!
    weak var baseDelegate: UITableViewDelegate!
    
    func configureFor(tableView: UITableView, baseDelegate: UITableViewDelegate) {
        self.tableView = tableView
        self.baseDelegate = baseDelegate
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func updateTableWith(goals: [SMGoal]) {
        self.goals = goals
        self.tableView.reloadData()
    }
}

extension SMGoalsDataDisplayManager: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return SMGoalCellObjectFactory.cellFor(goal: goals[indexPath.row], tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let deletingGoal = goals[indexPath.row]
            goals.remove(at: indexPath.row)
            
            SMModuleLocalPushes.shared.unsubscribeOnPushNotification(goal: deletingGoal)
            SMGoalService.deleteGoal(plainModel: deletingGoal)
            
            self.updateTableWith(goals: goals)
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "common_Delete".localized()
    }
}

extension SMGoalsDataDisplayManager: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.baseDelegate.responds(to: #selector(tableView(_:didSelectRowAt:))) {
            self.baseDelegate.tableView!(tableView, didSelectRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.baseDelegate.responds(to: #selector(tableView(_:heightForRowAt:))) {
            return self.baseDelegate.tableView!(tableView, heightForRowAt: indexPath)
        }
        return UITableViewAutomaticDimension
    }
}
