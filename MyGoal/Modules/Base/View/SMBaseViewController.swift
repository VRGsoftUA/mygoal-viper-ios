//
//  SMBaseViewController.swift
//  MyGoal
//
//  Created by OLEKSANDR SEMENIUK on 7/25/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

class SMBaseViewController: SMViewController {
    
    private var formatter: DateFormatter
        
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        formatter = DateFormatter()
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let navBarColor: UIColor? = self.navBarColor()
        
        if self.navigationController != nil {
            if navBarColor != nil {
                self.navigationController?.navigationBar.tintColor = navBarColor
                let navBarBackground = UIImage.imageWith(color: navBarColor!, size: CGSize(width: 1, height: 1)).resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
                self.navigationController?.navigationBar.setBackgroundImage(navBarBackground, for: .default)
            } else {
                self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                self.navigationController?.navigationBar.isTranslucent = true
            }
        }
    }
    
    func navBarColor() -> UIColor? {
        return nil
    }
    
    static let _bgImage: UIImage = UIImage(named: "bg_main.png")!
    override func backgroundImage() -> UIImage? {
        return SMBaseViewController._bgImage
    }
    
    func classNavigationController() -> AnyClass {
        return SMBaseNavigationController.self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func convertDateWithDate(_ aDate: Date, _ aFormat: String) -> String {
        var result: String?
        
        self.formatter.dateFormat = aFormat
        result = self.formatter.string(from: aDate)
        if result == nil {
            result = ""
        }
        
        return result!
    }
    
    func convertStringWithString(_ aString: String, _ aFormat: String) -> Date {
        var result: Date
        
        self.formatter.dateFormat = aFormat
        result = self.formatter.date(from: aString)!
        
        return result
    }
    
    func showAlertController(title aTitle: String?, message aMessage: String?) {
        self.sm_showAlertController(title: aTitle, message: aMessage, cancelButtonTitle: "OK")
    }
}
