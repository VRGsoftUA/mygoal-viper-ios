//
//  SMMatchGoalViewController.swift
//  Project: SMMyGoal
//
//  Module: MatchGoal
//
//  By OLEKSANDR SEMENIUK 7/26/17
//  VRG Soft 2017
//

import UIKit

class SMMatchGoalViewController: SMBaseViewController {

	var output: SMMatchGoalViewOutput!
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btCategory: UIButton!
    @IBOutlet weak var btEdit: UIButton!
    @IBOutlet weak var vParent: UIView!
    @IBOutlet weak var vBack: UIView!
    @IBOutlet weak var lbNotifications: UILabel!
    @IBOutlet weak var tfTime: UITextField!
    @IBOutlet weak var lbHabit: UILabel!
    @IBOutlet weak var lbQuestion: UILabel!
    @IBOutlet weak var btYes: UIButton!
    @IBOutlet weak var vProgress: UIView!
    
    fileprivate var timePicker = UIDatePicker()
    
    fileprivate var goal: SMGoal?
    
	override func viewDidLoad() {
    	super.viewDidLoad()
        
        SMUIConfigurator.shared.prepareShadowFor(button: self.btCategory, shadowWith: 0.7, shadowHeight: 0.7)
        SMUIConfigurator.shared.prepareShadowFor(button: self.btYes, shadowWith: 0, shadowHeight: 0.7)
        self.btYes.setTitle("common_Yes".localized(), for: .normal)
        
        lbTitle.text = "check_goal_title".localized()
        lbNotifications.text = "common_Notification_time".localized()
        
        vParent.layer.cornerRadius = 5
        vBack.sm_roundBorder()
        
        lbHabit.text = goal?.habit
        lbQuestion.text = goal?.question
        
        timePicker.datePickerMode = .time
        timePicker.backgroundColor = .white
        timePicker.date = (goal?.notificationTime)!
        timePicker.addTarget(self, action: #selector(didTimePickerValueChange(_:)), for: .valueChanged)
        tfTime.text = self.convertDateWithDate((goal?.notificationTime)!, "HH:mm")
        tfTime.inputView = timePicker
        tfTime.isEnabled = false
        
        let categ = SMCategoryType.SMCategory(rawValue: (goal?.categoryID)!)!
        btCategory.setImage(UIImage(named: categ.get().1), for: .normal)
        
		output.didLoadView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if progress.isAvailable {
            return
        }
        
        self.showAtRatioTypeSubView()
    }
    
    override func didBtNavLeftClicked() {
        output.didBtBackClicked()
    }
    
    @IBAction func didBtYesClicked(_ sender: Any) {
        
        if timePicker.date != goal?.notificationTime {
            goal?.notificationTime = timePicker.date
            output.didPushTimeUpdated(goal: goal!)
        }
        output.didBtYesClicked(goal: goal!)
    }
    
    @IBAction func didTimePickerValueChange(_ sender: Any) {
        tfTime.text = self.convertDateWithDate(timePicker.date, "HH:mm")
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
        tfTime.isEnabled = false
    }
    
    @IBAction func didBtEditClicked(_ sender: Any) {
        tfTime.isEnabled = true
        tfTime.becomeFirstResponder()
    }
    
    
    //MARK: ProgressView
    
    let progress = GradientCircularProgress()
    var progressView: UIView?
    
    var timer: Timer?
    var v: Double = 0.0
    
    func showAtRatioTypeSubView() {
        
        progressView = progress.showAtRatio(frame: vProgress.bounds, display: true, style: OrangeClearStyle())
        progressView?.layer.cornerRadius = 12.0
        vProgress.addSubview(progressView!)
        
        startProgressAtRatio()
    }
    
    func startProgressAtRatio() {
        v = 0.0
        
        timer = Timer.scheduledTimer(
            timeInterval: 0.03,
            target: self,
            selector: #selector(updateProgressAtRatio),
            userInfo: nil,
            repeats: true
        )
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    func updateProgressAtRatio() {
        
        if goal?.progress == 0 {
            timer!.invalidate()
            progress.updateRatio(CGFloat(v))
            
            return
        }
        
        v += 0.01
        progress.updateRatio(CGFloat(v))
        
        if v >= (Double((goal?.progress)!)/100) {
            timer!.invalidate()
            
            return
        }
    }
}


extension SMMatchGoalViewController: SMMatchGoalViewInput {
    
	func updateViewWith(title: String) {
        self.title = title
    }
    
    func updateViewWith(goal: SMGoal) {
        self.goal = goal
    }
}

extension SMMatchGoalViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.tfTime
        {
            timePicker.date = self.convertStringWithString(self.tfTime.text!, "HH:mm")
        }
        return true
    }
}
