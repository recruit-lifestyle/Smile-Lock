//
//  PasswordLoginViewController.swift
//  SmileLock-Example
//
//  Created by rain on 4/22/16.
//  Copyright © 2016 RECRUIT LIFESTYLE CO., LTD. All rights reserved.
//

import UIKit
import SmileLock

class PasswordLoginViewController: UIViewController {

    @IBOutlet weak var passwordStackView: UIStackView!
    
    //MARK: Property
    var passwordContainerView: PasswordContainerView!
    let kPasswordDigit = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create PasswordContainerView
        self.passwordContainerView = PasswordContainerView.create(in: passwordStackView, digit: kPasswordDigit)
        passwordContainerView.delegate = self
        
        //customize password UI
        self.passwordContainerView.tintColor = UIColor.color(.TextColor)
        self.passwordContainerView.highlightedColor = UIColor.color(.Blue)
    }
}

extension PasswordLoginViewController: PasswordInputCompleteProtocol {
    func passwordInputComplete(passwordContainerView: PasswordContainerView, input: String) {
        if self.validation(input) {
            self.validationSuccess()
        } else {
            self.validationFail()
        }
    }
    
    func touchAuthenticationComplete(passwordContainerView: PasswordContainerView, success: Bool) {
        if success {
            self.validationSuccess()
        } else {
            self.validationFail()
        }
    }
}

private extension PasswordLoginViewController {
    func validation(input: String) -> Bool {
        return input == "123456"
    }
    
    func validationSuccess() {
        print("*️⃣ success!")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func validationFail() {
        print("*️⃣ failure!")
        self.passwordContainerView.wrongPassword()
    }
}
