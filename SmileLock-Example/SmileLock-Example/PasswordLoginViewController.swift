//
//  PasswordLoginViewController.swift
//  regi-iOS-global
//
//  Created by rain on 4/22/16.
//  Copyright © 2016 RECRUIT LIFESTYLE CO., LTD. All rights reserved.
//

import UIKit
import SmileLock

class PasswordLoginViewController: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var baseView: UIView!
    
    //MARK: Property
    var passwordContainerView: PasswordContainerView!
    let kPasswordDigit = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.baseView.backgroundColor = UIColor.clearColor()
        self.configurePasswordView()
    }
}

private extension PasswordLoginViewController {
    func configurePasswordView() {
        self.passwordContainerView = PasswordContainerView.createWithDigit(kPasswordDigit)
        NSLayoutConstraint.addEqualConstraintsFromSubView(self.passwordContainerView, toSuperView: self.baseView)
        self.passwordContainerView.delegate = self
        self.passwordContainerView.tintColor = UIColor.color(.TextColor)
        self.passwordContainerView.hightlightedColor = UIColor.color(.Blue)
    }
    
    func validationFail() {
        self.passwordContainerView.wrongPassword()
    }
    
    func validationSuccess() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension PasswordLoginViewController: PasswordInputCompleteProtocol {
    func passwordInputComplete(passwordContainerView: PasswordContainerView, input: String) {
        print("input completed -> \(input)")
        self.validationFail()
    }
}

