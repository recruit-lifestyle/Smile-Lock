//
//  BlurPasswordLoginViewController.swift
//
//  Created by rain on 4/22/16.
//  Copyright © 2016 Yuchen Liu All rights reserved.
//

import UIKit
import SmileLock

class BlurPasswordLoginViewController: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var baseView: UIView!
    
    //MARK: Property
    var passwordContainerView: PasswordContainerView!
    let kPasswordDigit = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.baseView.backgroundColor = UIColor.clearColor()
        self.configurePasswordView()
        
        self.passwordContainerView.passwordInputViews.forEach { passwordInputView in
            let label = passwordInputView.label
            label.removeFromSuperview()
            self.view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.addConstraintsFromView(label, toView: passwordInputView, constraintInsets: UIEdgeInsetsZero)
        }
    }
    
    func validationFail() {
        self.passwordContainerView.wrongPassword()
    }
    
    func validationSuccess() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

private extension BlurPasswordLoginViewController {
    func configurePasswordView() {
        self.passwordContainerView = PasswordContainerView.createWithDigit(kPasswordDigit)
        NSLayoutConstraint.addEqualConstraintsFromSubView(self.passwordContainerView, toSuperView: self.baseView)
        self.passwordContainerView.delegate = self
        self.passwordContainerView.isVibrancyEffect = true
    }
}

extension BlurPasswordLoginViewController: PasswordInputCompleteProtocol {
    func passwordInputComplete(passwordContainerView: PasswordContainerView, input: String) {
        print("input completed -> \(input)")
        self.performSelector(#selector(PasswordLoginViewController.validationFail), withObject: nil, afterDelay: 0.3)
    }
}

