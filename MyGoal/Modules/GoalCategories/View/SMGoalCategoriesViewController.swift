//
//  SMGoalCategoriesViewController.swift
//  Project: SMMyGoal
//
//  Module: GoalCategories
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import UIKit

class SMGoalCategoriesViewController: SMBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ivBack: UIImageView!
    
    var output: SMGoalCategoriesViewOutput!
    
    var displayManager = SMCategoriesDataDisplayManager()
    
    var categories: [SMCategoryType.SMCategory] = []
    
	override func viewDidLoad() {
    	super.viewDidLoad()
        
        ivBack.image = UIImage(named: "bg_dialog.png")
        
        displayManager.configureFor(tableView: tableView, baseDelegate: self)
        
        output.didLoadView()
    }
    
    override func backgroundImage() -> UIImage? {
        return nil
    }
}


extension SMGoalCategoriesViewController: SMGoalCategoriesViewInput {
    func updateViewWith(categories: [SMCategoryType.SMCategory]) {
        self.categories = categories
        displayManager.updateTableWith(categories: categories)
    }


	func updateViewWith(title: String) {
        self.title = title
    }
}

extension SMGoalCategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        output.didSelect(category: categories[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
