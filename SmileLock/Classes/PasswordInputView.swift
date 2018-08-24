//
//  PasswordInputView.swift
//
//  Created by rain on 4/21/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.
//

import UIKit

public protocol PasswordInputViewTappedProtocol: class {
    func passwordInputView(_ passwordInputView: PasswordInputView, tappedString: String)
}

@IBDesignable
open class PasswordInputView: UIView {
    
    //MARK: Property
    open weak var delegate: PasswordInputViewTappedProtocol?
    
    let circleView = UIView()
    let button = UIButton()
    open let label = UILabel()
    open var labelFont: UIFont?
    fileprivate let fontSizeRatio: CGFloat = 46 / 40
    fileprivate let borderWidthRatio: CGFloat = 1 / 26
    fileprivate var touchUpFlag = true
    fileprivate(set) open var isAnimating = false
    var isVibrancyEffect = false
    
    @IBInspectable
    open var numberString = "2" {
        didSet {
            label.text = numberString
        }
    }
    
    @IBInspectable
    open var borderColor = UIColor.darkGray {
        didSet {
            backgroundColor = borderColor
        }
    }
    
    @IBInspectable
    open var circleBackgroundColor = UIColor.white {
        didSet {
            circleView.backgroundColor = circleBackgroundColor
        }
    }
    
    @IBInspectable
    open var textColor = UIColor.darkGray {
        didSet {
            label.textColor = textColor
        }
    }
    
    @IBInspectable
    open var highlightBackgroundColor = UIColor.red
    
    @IBInspectable
    open var highlightTextColor = UIColor.white
    
    //MARK: Life Cycle
    #if TARGET_INTERFACE_BUILDER
    override public func willMoveToSuperview(newSuperview: UIView?) {
        configureSubviews()
    }
    #else
    override open func awakeFromNib() {
        super.awakeFromNib()
        configureSubviews()
    }
    #endif

    @objc func touchDown() {
        //delegate callback
        delegate?.passwordInputView(self, tappedString: numberString)
        
        //now touch down, so set touch up flag --> false
        touchUpFlag = false
        touchDownAnimation()
    }
    
    @objc func touchUp() {
        //now touch up, so set touch up flag --> true
        touchUpFlag = true
        
        //only show touch up animation when touch down animation finished
        if !isAnimating {
            touchUpAnimation()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    fileprivate func getLabelFont() -> UIFont {
        if labelFont != nil {
            return labelFont!
        }
        
        let width = bounds.width
        let height = bounds.height
        let radius = min(width, height) / 2
        return UIFont.systemFont(ofSize: radius * fontSizeRatio,
                                 weight: touchUpFlag ? UIFont.Weight.thin : UIFont.Weight.regular)
    }
    
    fileprivate func updateUI() {
        //prepare calculate
        let width = bounds.width
        let height = bounds.height
        let center = CGPoint(x: width/2, y: height/2)
        let radius = min(width, height) / 2
        let borderWidth = radius * borderWidthRatio
        let circleRadius = radius - borderWidth
        
        //update label
        label.text = numberString
        
        label.font = getLabelFont()
        
        label.textColor = textColor
        
        //update circle view
        circleView.frame = CGRect(x: 0, y: 0, width: 2 * circleRadius, height: 2 * circleRadius)
        circleView.center = center
        circleView.layer.cornerRadius = circleRadius
        circleView.backgroundColor = circleBackgroundColor
        //circle view border
        circleView.layer.borderWidth = isVibrancyEffect ? borderWidth : 0
        
        //update mask
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2.0 * CGFloat(Double.pi), clockwise: false)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
        
        //update color
        backgroundColor = borderColor
    }
}

private extension PasswordInputView {
    //MARK: Awake
    func configureSubviews() {
        addSubview(circleView)

        //configure label
        NSLayoutConstraint.addEqualConstraintsFromSubView(label, toSuperView: self)
        label.textAlignment = .center
        label.isAccessibilityElement = false
        
        //configure button
        NSLayoutConstraint.addEqualConstraintsFromSubView(button, toSuperView: self)
        button.isExclusiveTouch = true
        button.addTarget(self, action: #selector(PasswordInputView.touchDown), for: [.touchDown])
        button.addTarget(self, action: #selector(PasswordInputView.touchUp), for: [.touchUpInside, .touchDragOutside, .touchCancel, .touchDragExit])
        button.accessibilityValue = numberString
    }
    
    //MARK: Animation
    func touchDownAction() {
        label.font = getLabelFont()
        label.textColor = highlightTextColor
        if !self.isVibrancyEffect {
            backgroundColor = highlightBackgroundColor
        }
        circleView.backgroundColor = highlightBackgroundColor
    }
    
    func touchUpAction() {
        label.font = getLabelFont()
        label.textColor = textColor
        backgroundColor = borderColor
        circleView.backgroundColor = circleBackgroundColor
    }
    
    func touchDownAnimation() {
        isAnimating = true
        tappedAnimation(animations: { 
            self.touchDownAction()
        }) {
            if self.touchUpFlag {
                self.touchUpAnimation()
            } else {
                self.isAnimating = false
            }
        }
    }
    
    func touchUpAnimation() {
        isAnimating = true
        tappedAnimation(animations: { 
            self.touchUpAction()
        }) {
            self.isAnimating = false
        }
    }
    
    func tappedAnimation(animations: @escaping () -> (), completion: (() -> ())?) {
        UIView.animate(withDuration: 0.25, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: animations) { _ in
            completion?()
        }
    }
}

internal extension NSLayoutConstraint {
    class func addConstraints(fromView view: UIView, toView baseView: UIView, constraintInsets insets: UIEdgeInsets) {
        baseView.topAnchor.constraint(equalTo: view.topAnchor, constant: -insets.top)
        let topConstraint = baseView.topAnchor.constraint(equalTo: view.topAnchor, constant: -insets.top)
        let bottomConstraint = baseView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom)
        let leftConstraint = baseView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -insets.left)
        let rightConstraint = baseView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: insets.right)
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
    }
    
    class func addEqualConstraintsFromSubView(_ subView: UIView, toSuperView superView: UIView) {
        superView.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.addConstraints(fromView: subView, toView: superView, constraintInsets: UIEdgeInsets.zero)
    }
    
    class func addConstraints(fromSubview subview: UIView, toSuperView superView: UIView, constraintInsets insets: UIEdgeInsets) {
        superView.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.addConstraints(fromView: subview, toView: superView, constraintInsets: insets)
    }
}
