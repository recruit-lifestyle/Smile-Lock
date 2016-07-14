//
//  PasswordView.swift
//
//  Created by rain on 4/21/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.
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
            passwordDotView.inputDotCount = inputString.characters.count
            checkInputComplete()
        }
    }
    
    public var isVibrancyEffect = false {
        didSet {
            configureVibrancyEffect()
        }
    }
    
    public override var tintColor: UIColor! {
        didSet {
            if isVibrancyEffect { return }
            deleteButton.setTitleColor(tintColor, forState: .Normal)
            passwordDotView.strokeColor = tintColor
            passwordInputViews.forEach {
                $0.textColor = tintColor
                $0.borderColor = tintColor
            }
        }
    }
    
    public var highlightedColor: UIColor! {
        didSet {
            if isVibrancyEffect { return }
            passwordDotView.fillColor = highlightedColor
            passwordInputViews.forEach {
                $0.highlightBackgroundColor = highlightedColor
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
        backgroundColor = UIColor.clearColor()
        passwordInputViews.forEach {
            $0.delegate = self
        }
        deleteButton.titleLabel?.adjustsFontSizeToFitWidth = true
        deleteButton.titleLabel?.minimumScaleFactor = 0.5
    }
    
    //MARK: Input Wrong
    public func wrongPassword() {
        passwordDotView.shakeAnimationWithCompletion {
            self.inputString = ""
        }
    }
    
    //MARK: IBAction
    @IBAction func deleteInputString(sender: AnyObject) {
        guard inputString.characters.count > 0 && !passwordDotView.isFull  else {
            return
        }
        inputString = String(inputString.characters.dropLast())
    }
}

private extension PasswordContainerView {
    func checkInputComplete() {
        if inputString.characters.count == passwordDotView.totalDotCount {
            delegate?.passwordInputComplete(self, input: inputString)
        }
    }
    func configureVibrancyEffect() {
        let whiteColor = UIColor.whiteColor()
        let clearColor = UIColor.clearColor()
        //delete button title color
        var titleColor: UIColor!
        //dot view stroke color
        var strokeColor: UIColor!
        //dot view fill color
        var fillColor: UIColor!
        //input view background color
        var circleBackgroundColor: UIColor!
        var highlightBackgroundColor: UIColor!
        var borderColor: UIColor!
        //input view text color
        var textColor: UIColor!
        var highlightTextColor: UIColor!
        
        if isVibrancyEffect {
            //delete button
            titleColor = whiteColor
            //dot view
            strokeColor = whiteColor
            fillColor = whiteColor
            //input view
            circleBackgroundColor = clearColor
            highlightBackgroundColor = whiteColor
            borderColor = clearColor
            textColor = whiteColor
            highlightTextColor = whiteColor
        } else {
            //delete button
            titleColor = tintColor
            //dot view
            strokeColor = tintColor
            fillColor = highlightedColor
            //input view
            circleBackgroundColor = whiteColor
            highlightBackgroundColor = highlightedColor
            borderColor = tintColor
            textColor = tintColor
            highlightTextColor = highlightedColor
        }
        
        deleteButton.setTitleColor(titleColor, forState: .Normal)
        passwordDotView.strokeColor = strokeColor
        passwordDotView.fillColor = fillColor
        passwordInputViews.forEach { passwordInputView in
            passwordInputView.circleBackgroundColor = circleBackgroundColor
            passwordInputView.borderColor = borderColor
            passwordInputView.textColor = textColor
            passwordInputView.highlightTextColor = highlightTextColor
            passwordInputView.highlightBackgroundColor = highlightBackgroundColor
            passwordInputView.circleView.layer.borderColor = UIColor.whiteColor().CGColor
            //borderWidth as a flag, will recalculate in PasswordInputView.updateUI()
            passwordInputView.circleView.layer.borderWidth = isVibrancyEffect ? 1 : 0
        }
    }
}

extension PasswordContainerView: PasswordInputViewTappedProtocol {
    public func passwordInputView(passwordInputView: PasswordInputView, tappedString: String) {
        guard inputString.characters.count < passwordDotView.totalDotCount else {
            return
        }
        inputString += tappedString
    }
}
