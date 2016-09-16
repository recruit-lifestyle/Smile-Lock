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
        passwordContainerView = PasswordContainerView.create(in: passwordStackView, digit: kPasswordDigit)
        passwordContainerView.delegate = self
        
        //customize password UI
        passwordContainerView.tintColor = UIColor.color(.textColor)
        passwordContainerView.highlightedColor = UIColor.color(.blue)
    }
}

extension PasswordLoginViewController: PasswordInputCompleteProtocol {
    func passwordInputComplete(_ passwordContainerView: PasswordContainerView, input: String) {
        if validation(input) {
            validationSuccess()
        } else {
            validationFail()
        }
    }
    
    func touchAuthenticationComplete(_ passwordContainerView: PasswordContainerView, success: Bool, error: Error?) {
        if success {
            self.validationSuccess()
        } else {
            passwordContainerView.clearInput()
        }
    }
}

private extension PasswordLoginViewController {
    func validation(_ input: String) -> Bool {
        return input == "123456"
    }
    
    func validationSuccess() {
        print("*️⃣ success!")
        dismiss(animated: true, completion: nil)
    }
    
    func validationFail() {
        print("*️⃣ failure!")
        passwordContainerView.wrongPassword()
    }
}
