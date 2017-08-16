//
//  SMCreateGoalViewController.swift
//  Project: SMMyGoal
//
//  Module: CreateGoal
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import UIKit

class SMCreateGoalViewController: SMBaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btCategory: UIButton!
    @IBOutlet weak var vParent: UIView!
    @IBOutlet weak var tfHabit: SMFloatingTextField!
    @IBOutlet weak var tfQuestion: SMFloatingTextField!
    @IBOutlet weak var lbNotifications: UILabel!
    @IBOutlet weak var btSave: UIButton!
    @IBOutlet weak var btCancel: UIButton!
    @IBOutlet weak var tfTime: UITextField!
    @IBOutlet weak var swNotific: UISwitch!
    
    fileprivate var timePicker = UIDatePicker()
    
	var output: SMCreateGoalViewOutput!
    
	override func viewDidLoad() {
    	super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrameNotification(_:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        lbTitle.text = "create_goal_title".localized()
        lbNotifications.text = "common_Notification_time".localized()
        
        SMUIConfigurator.shared.prepareShadowFor(button: btCategory, shadowWith: 0.7, shadowHeight: 0.7)
        btCategory.setImage(UIImage(named: "icon_other"), for: .normal)
        
        SMUIConfigurator.shared.prepareShadowFor(button: btSave, shadowWith: 0, shadowHeight: 0.7)
        btSave.setTitle("common_Save".localized(), for: .normal)
        
        SMUIConfigurator.shared.prepareShadowFor(button: btCancel, shadowWith: 0, shadowHeight: 0.7)
        btCancel.setTitle("common_Cancel".localized(), for: .normal)
        
        vParent.layer.cornerRadius = 5
        
        tfHabit.delegate = self
        tfHabit.placeholder = "create_goal_tf_habit".localized()
        tfHabit.vLine?.backgroundColor = UIColor.darkGray
        tfHabit.placeholderColor = UIColor.lightGray
        tfHabit.lbPlaceHolder?.font = UIFont(name: SMUIConfigurator.shared.fonts.regular, size: 13)
        
        tfQuestion.delegate = self
        tfQuestion.placeholder = "create_goal_tf_question".localized()
        tfQuestion.vLine?.backgroundColor = UIColor.darkGray
        tfQuestion.placeholderColor = UIColor.lightGray
        tfQuestion.lbPlaceHolder?.font = UIFont(name: SMUIConfigurator.shared.fonts.regular, size: 13)
        
        timePicker.datePickerMode = .time
        timePicker.backgroundColor = .white
        timePicker.addTarget(self, action: #selector(didTimePickerValueChange(_:)), for: .valueChanged)
        tfTime.inputView = self.timePicker
        tfTime.isEnabled = false
        
        swNotific.isOn = false
        
		output.didLoadView()
        
        btCancel.addTarget(self, action: #selector(didBtNavLeftClicked), for: .touchUpInside)
    }
    
    override func didBtNavLeftClicked() {
        output.didBtBackClicked()
    }
    
    @IBAction func didBtSaveClicked(_ sender: Any) {
        
        if !(tfHabit.text?.isEmpty)! {
            let goal: SMGoal = SMGoal(categoryID: 1, createDate: Date(), habit: tfHabit.text!, identifier: Int(Date().timeIntervalSince1970), lastUpdate: Date(), notificationTime: timePicker.date, progress: 0, question: tfQuestion.text)
            output.didBtCreateClicked(goal: goal)
        } else {
            self.showAlertController(title: "alert_title_error".localized(), message: "alert_empty_habit_name".localized())
        }
        
    }
    
    @IBAction func didBtSelectCategoryClicked(_ sender: Any) {
        output.didBtSelectCategoryClicked()
    }
    
    @IBAction func didTimePickerValueChange(_ sender: Any) {
        tfTime.text = self.convertDateWithDate(timePicker.date, "HH:mm")
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func didNotificationTurnOff(_ sender: UISwitch) {
        if sender.isOn {
            tfTime.isEnabled = true
            tfTime.becomeFirstResponder()
        } else {
            tfTime.isEnabled = false
            tfTime.text = nil
        }
    }
    
    
    //MARK: Notification
    
    func keyboardWillHideNotification(_ notification: Notification) -> Void {
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    func keyboardWillChangeFrameNotification(_ notification: Notification) -> Void {
        if let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
}

extension SMCreateGoalViewController: SMCreateGoalViewInput {

	func updateViewWith(title: String) {
        self.title = title
    }
    
    func updateViewWith(category: SMCategoryType.SMCategory) {
        btCategory.setImage(UIImage(named: category.get().1), for: .normal)
    }
}

extension SMCreateGoalViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var result = true
        if textField == tfHabit {
            result = tfQuestion.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return result
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfTime {
            timePicker.date = self.convertStringWithString(tfTime.text!, "HH:mm")
        }
        return true
    }
    
}
