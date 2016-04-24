//
//  PasswordInputView.swift
//
//  Created by rain on 4/21/16.
//  Copyright © 2016 Yuchen Liu All rights reserved.
//

import UIKit

public protocol PasswordInputViewTappedProtocol: class {
    func passwordInputView(passwordInputView: PasswordInputView, tappedString: String)
}

@IBDesignable
public class PasswordInputView: UIView {
    
    //MARK: Property
    public weak var delegate: PasswordInputViewTappedProtocol?
    
    private let circleView = UIView()
    private let button = UIButton()
    private let label = UILabel()
    private let fontSizeRatio: CGFloat = 46 / 40
    private let borderWidthRatio: CGFloat = 1 / 26
    private var touchUpFlag = false
    private var isAnimating = false
    
    @IBInspectable
    public var numberString: String = "2" {
        didSet {
            self.updateUI()
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor = UIColor.darkGrayColor() {
        didSet {
            self.updateUI()
        }
    }
    
    @IBInspectable
    public var circleBackgroundColor: UIColor = UIColor.whiteColor() {
        didSet {
            self.updateUI()
        }
    }

    @IBInspectable
    public var highlightBackgroundColor: UIColor = UIColor.redColor() {
        didSet {
            self.updateUI()
        }
    }
    
    @IBInspectable
    public var textColor: UIColor = UIColor.darkGrayColor() {
        didSet {
            self.updateUI()
        }
    }
    
    @IBInspectable
    public var highlightTextColor: UIColor = UIColor.whiteColor() {
        didSet {
            self.updateUI()
        }
    }
    
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
        self.configureSubviews()
    }
    #else
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.configureSubviews()
    }
    #endif

    func touchDown() {
        //delegate callback
        self.delegate?.passwordInputView(self, tappedString: self.numberString)
        
        //now touch down, so set touch up flag --> false
        self.touchUpFlag = false
        self.touchDownAnimation()
    }
    
    func touchUp() {
        //now touch up, so set touch up flag --> true
        self.touchUpFlag = true
        
        //only show touch up animation when touch down animation finished        
        if !self.isAnimating {
            self.touchUpAnimation()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.updateUI()
    }
    
    private func updateUI() {
        //prepare calculate
        let width = CGRectGetWidth(self.bounds)
        let height = CGRectGetHeight(self.bounds)
        let center = CGPoint(x: width/2, y: height/2)
        let radius = min(width, height) / 2
        let borderWidth = radius * borderWidthRatio
        let circleRadius = radius - borderWidth
        
        //update label
        self.label.text = self.numberString
        self.label.font = UIFont.systemFontOfSize( radius * fontSizeRatio, weight: UIFontWeightThin)
        self.label.textColor = self.textColor
        
        //update circle view
        self.circleView.frame = CGRect(x: 0, y: 0, width: 2 * circleRadius, height: 2 * circleRadius)
        self.circleView.center = center
        self.circleView.layer.cornerRadius = circleRadius
        self.circleView.backgroundColor = self.circleBackgroundColor
        
        //update mask
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2.0 * CGFloat(M_PI), clockwise: false)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.CGPath
        self.layer.mask = maskLayer
        
        //update color
        self.backgroundColor = self.borderColor
    }
}

private extension PasswordInputView {
    //MARK: Awake
    func configureSubviews() {
        self.addSubview(self.circleView)

        //configure label
        NSLayoutConstraint.addEqualConstraintsFromSubView(self.label, toSuperView: self)
        self.label.textAlignment = .Center
        
        //configure button
        NSLayoutConstraint.addEqualConstraintsFromSubView(self.button, toSuperView: self)
        self.button.exclusiveTouch = true
        self.button.addTarget(self, action: #selector(PasswordInputView.touchDown), forControlEvents: [.TouchDown])
        self.button.addTarget(self, action: #selector(PasswordInputView.touchUp), forControlEvents: [.TouchUpInside, .TouchDragOutside, .TouchCancel, .TouchDragExit])
    }
    
    //MARK: Animation
    func touchDownAction() {
        let originFont = self.label.font
        self.label.font = UIFont.systemFontOfSize(originFont.pointSize, weight: UIFontWeightLight)
        self.label.textColor = self.highlightTextColor
        self.backgroundColor = self.highlightBackgroundColor
        self.circleView.backgroundColor = self.highlightBackgroundColor
    }
    
    func touchUpAction() {
        let originFont = self.label.font
        self.label.font = UIFont.systemFontOfSize(originFont.pointSize, weight: UIFontWeightThin)
        self.label.textColor = self.textColor
        self.backgroundColor = self.borderColor
        self.circleView.backgroundColor = self.circleBackgroundColor
    }
    
    func touchDownAnimation() {
        self.isAnimating = true
        self.tappedAnimation({
            self.touchDownAction()
            }, WithCompletion: {
                if self.touchUpFlag {
                    self.touchUpAnimation()
                } else {
                    self.isAnimating = false
                }
        })
    }
    
    func touchUpAnimation() {
        self.isAnimating = true
        self.tappedAnimation({
            self.touchUpAction()
            }, WithCompletion: {
                self.isAnimating = false
        })
    }
    
    func tappedAnimation(animation: () -> (), WithCompletion completion: (() -> ())?) {
        UIView.animateWithDuration(0.25, delay: 0, options: [.AllowUserInteraction, .BeginFromCurrentState], animations: {
            animation()
            }) { _ in
                guard let completion = completion else {
                    return
                }
                completion()
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
