//
//  SMGoalsListViewController.swift
//  Project: SMMyGoal
//
//  Module: GoalsList
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import UIKit

class SMGoalsListViewController: SMBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!

	var output: SMGoalsListViewOutput!
    
    var displayManager = SMGoalsDataDisplayManager()
    
    var goals: [SMGoal] = []
    
	override func viewDidLoad() {
    	super.viewDidLoad()
        
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didBtCreateGoalClicked))
        button.tintColor = UIColor.darkGray
        button.accessibilityLabel = "Add"
        navigationItem.rightBarButtonItem = button
        
        displayManager.configureFor(tableView: tableView, baseDelegate: self)
        
		output.didLoadView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        output.didReloadView()
    }
    
    func didBtCreateGoalClicked() {
        output.didBtCreateGoalClicked()
    }
}

extension SMGoalsListViewController: SMGoalsListViewInput {

	func updateViewWith(title: String) {
        self.title = title
    }
    
    func updateViewWith(goals: [SMGoal]) {
        self.goals = goals
        displayManager.updateTableWith(goals: goals)
    }
}

extension SMGoalsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        output.didSelect(goal: goals[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
