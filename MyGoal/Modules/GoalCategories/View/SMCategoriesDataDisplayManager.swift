//
//  SMCategoriesDataDisplayManager.swift
//  MyGoal
//
//  Created by OLEKSANDR SEMENIUK on 8/1/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

class SMCategoriesDataDisplayManager: NSObject {

    var categories: [SMCategoryType.SMCategory] = []
    var tableView: UITableView!
    weak var baseDelegate: UITableViewDelegate!
    
    func configureFor(tableView: UITableView, baseDelegate: UITableViewDelegate) {
        self.tableView = tableView
        self.baseDelegate = baseDelegate
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func updateTableWith(categories: [SMCategoryType.SMCategory]) {
        self.categories = categories
        self.tableView.reloadData()
    }
}

extension SMCategoriesDataDisplayManager: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return SMCategoryCellObjectFactory.cellFor(category: categories[indexPath.row], tableView: tableView)
    }
}

extension SMCategoriesDataDisplayManager: UITableViewDelegate {
    
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

