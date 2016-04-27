//
//  PasswordView.swift
//
//  Created by rain on 4/21/16.
//  Copyright © 2016 Yuchen Liu All rights reserved.
//

import UIKit

public protocol PasswordInputCompleteProtocol: class {
    func passwordInputComplete(passwordContainerView: PasswordContainerView, input: String)
}

public class PasswordContainerView: UIView {
    
    //MARK: IBOutlet
    @IBOutlet public var passwordInputViews: [PasswordInputView]!
    @IBOutlet public weak var passwordDotView: PasswordDotView!
    @IBOutlet weak var deleteButton: UIButton!
    
    //MARK: Property
    public weak var delegate: PasswordInputCompleteProtocol?
    
    private var inputString: String = "" {
        didSet {
            self.passwordDotView.inputDotCount = self.inputString.characters.count
            self.checkInputComplete()
        }
    }
    
    public override var tintColor: UIColor! {
        didSet {
            self.passwordDotView.strokeColor = tintColor
            passwordInputViews.forEach {
                $0.textColor = tintColor
                $0.borderColor = tintColor
            }
        }
    }
    
    public var hightlightedColor: UIColor! {
        didSet {
            self.passwordDotView.fillColor = hightlightedColor
            passwordInputViews.forEach {
                $0.highlightBackgroundColor = hightlightedColor
            }
        }
    }
    
    //MARK: Init
    public class func createWithDigit(digit: Int) -> PasswordContainerView {
        let bundle = NSBundle(forClass: PasswordContainerView.self)
        let nib = UINib(nibName: "PasswordContainerView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! PasswordContainerView
        view.passwordDotView.totalDotCount = digit
        return view
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
        passwordInputViews.forEach {
            $0.delegate = self
        }
        self.deleteButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.deleteButton.titleLabel?.minimumScaleFactor = 0.5
    }
    
    //MARK: Input Wrong
    public func wrongPassword() {
        self.passwordDotView.shakeAnimationWithCompletion {
            self.inputString = ""
        }
    }
    
    //MARK: IBAction
    @IBAction func deleteInputString(sender: AnyObject) {
        guard self.inputString.characters.count > 0 && !self.passwordDotView.isFull  else {
            return
        }
        self.inputString = String(self.inputString.characters.dropLast())
    }
}

private extension PasswordContainerView {
    func checkInputComplete() {
        if self.inputString.characters.count == self.passwordDotView.totalDotCount {
            self.delegate?.passwordInputComplete(self, input: self.inputString)
        }
    }
}

extension PasswordContainerView: PasswordInputViewTappedProtocol {
    public func passwordInputView(passwordInputView: PasswordInputView, tappedString: String) {
        guard inputString.characters.count < passwordDotView.totalDotCount else {
            return
        }
        self.inputString += tappedString
    }
}
