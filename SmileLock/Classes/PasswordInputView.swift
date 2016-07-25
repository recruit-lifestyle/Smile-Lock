//
//  PasswordInputView.swift
//
//  Created by rain on 4/21/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.
//

import UIKit

public protocol PasswordInputViewTappedProtocol: class {
    func passwordInputView(passwordInputView: PasswordInputView, tappedString: String)
}

@IBDesignable
public class PasswordInputView: UIView {
    
    //MARK: Property
    public weak var delegate: PasswordInputViewTappedProtocol?
    
    let circleView = UIView()
    let button = UIButton()
    public let label = UILabel()
    private let fontSizeRatio: CGFloat = 46 / 40
    private let borderWidthRatio: CGFloat = 1 / 26
    private var touchUpFlag = false
    private(set) public var isAnimating = false
    var isVibrancyEffect = false
    
    @IBInspectable
    public var numberString: String = "2" {
        didSet {
            label.text = numberString
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor = UIColor.darkGrayColor() {
        didSet {
            backgroundColor = borderColor
        }
    }
    
    @IBInspectable
    public var circleBackgroundColor: UIColor = UIColor.whiteColor() {
        didSet {
            circleView.backgroundColor = circleBackgroundColor
        }
    }
    
    @IBInspectable
    public var textColor: UIColor = UIColor.darkGrayColor() {
        didSet {
            label.textColor = textColor
        }
    }
    
    @IBInspectable
    public var highlightBackgroundColor: UIColor = UIColor.redColor()
    
    @IBInspectable
    public var highlightTextColor: UIColor = UIColor.whiteColor()
    
    //MARK: Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Life Cycle
    #if TARGET_INTERFACE_BUILDER
    override public func willMoveToSuperview(newSuperview: UIView?) {
        configureSubviews()
    }
    #else
    override public func awakeFromNib() {
        super.awakeFromNib()
        configureSubviews()
    }
    #endif

    func touchDown() {
        //delegate callback
        delegate?.passwordInputView(self, tappedString: numberString)
        
        //now touch down, so set touch up flag --> false
        touchUpFlag = false
        touchDownAnimation()
    }
    
    func touchUp() {
        //now touch up, so set touch up flag --> true
        touchUpFlag = true
        
        //only show touch up animation when touch down animation finished
        if !isAnimating {
            touchUpAnimation()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    private func updateUI() {
        //prepare calculate
        let width = CGRectGetWidth(bounds)
        let height = CGRectGetHeight(bounds)
        let center = CGPoint(x: width/2, y: height/2)
        let radius = min(width, height) / 2
        let borderWidth = radius * borderWidthRatio
        let circleRadius = radius - borderWidth
        
        //update label
        label.text = numberString
        label.font = UIFont.systemFontOfSize( radius * fontSizeRatio, weight: UIFontWeightThin)
        label.textColor = textColor
        
        //update circle view
        circleView.frame = CGRect(x: 0, y: 0, width: 2 * circleRadius, height: 2 * circleRadius)
        circleView.center = center
        circleView.layer.cornerRadius = circleRadius
        circleView.backgroundColor = circleBackgroundColor
        //circle view border
        circleView.layer.borderWidth = isVibrancyEffect ? borderWidth : 0
        
        //update mask
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2.0 * CGFloat(M_PI), clockwise: false)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.CGPath
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
        label.textAlignment = .Center
        
        //configure button
        NSLayoutConstraint.addEqualConstraintsFromSubView(button, toSuperView: self)
        button.exclusiveTouch = true
        button.addTarget(self, action: #selector(PasswordInputView.touchDown), forControlEvents: [.TouchDown])
        button.addTarget(self, action: #selector(PasswordInputView.touchUp), forControlEvents: [.TouchUpInside, .TouchDragOutside, .TouchCancel, .TouchDragExit])
    }
    
    //MARK: Animation
    func touchDownAction() {
        let originFont = label.font
        label.font = UIFont.systemFontOfSize(originFont.pointSize, weight: UIFontWeightLight)
        label.textColor = highlightTextColor
        if !self.isVibrancyEffect {
            backgroundColor = highlightBackgroundColor
        }
        circleView.backgroundColor = highlightBackgroundColor
    }
    
    func touchUpAction() {
        let originFont = label.font
        label.font = UIFont.systemFontOfSize(originFont.pointSize, weight: UIFontWeightThin)
        label.textColor = textColor
        backgroundColor = borderColor
        circleView.backgroundColor = circleBackgroundColor
    }
    
    func touchDownAnimation() {
        isAnimating = true
        tappedAnimation ({
            self.touchDownAction()
            }, withCompletion: {
                if self.touchUpFlag {
                    self.touchUpAnimation()
                } else {
                    self.isAnimating = false
                }
        })
    }
    
    func touchUpAnimation() {
        isAnimating = true
        tappedAnimation ({
            self.touchUpAction()
            }, withCompletion: {
                self.isAnimating = false
        })
    }
    
    func tappedAnimation(animation: () -> (), withCompletion completion: (() -> ())?) {
        UIView.animateWithDuration(0.25, delay: 0, options: [.AllowUserInteraction, .BeginFromCurrentState], animations: animation) { _ in
            completion?()
        }
    }
}

internal extension NSLayoutConstraint {
    class func addConstraintsFromView(view: UIView, toView baseView: UIView, constraintInsets insets: UIEdgeInsets) {
        baseView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: -insets.top)
        let topConstraint = baseView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: -insets.top)
        let bottomConstraint = baseView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: insets.bottom)
        let leftConstraint = baseView.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: -insets.left)
        let rightConstraint = baseView.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: insets.right)
        NSLayoutConstraint.activateConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
    }
    
    class func addEqualConstraintsFromSubView(subView: UIView, toSuperView superView: UIView) {
        superView.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.addConstraintsFromView(subView, toView: superView, constraintInsets: UIEdgeInsetsZero)
    }
    
    class func addConstraintsFromSubView(subView: UIView, toSuperView superView: UIView, constraintInsets insets: UIEdgeInsets) {
        superView.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.addConstraintsFromView(subView, toView: superView, constraintInsets: insets)
    }
}
