//
//  PasswordDotView.swift
//
//  Created by rain on 4/21/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.
//

import UIKit

@IBDesignable
public class PasswordDotView: UIView {
    
    //MARK: Property
    @IBInspectable
    public var inputDotCount: Int = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var totalDotCount: Int = 6 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var strokeColor: UIColor = UIColor.darkGrayColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var fillColor: UIColor = UIColor.redColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }

    private var radius: CGFloat = 6
    private let spacingRatio: CGFloat = 2
    private let borderWidthRatio: CGFloat = 1 / 5
    
    private var _isFull = false
    public  var isFull: Bool {
        return _isFull
    }
    
    //MARK: Draw
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self._isFull = (self.inputDotCount == self.totalDotCount)
        self.strokeColor.setStroke()
        self.fillColor.setFill()
        let isOdd = (self.totalDotCount % 2) != 0
        let positions = self.getDotPositions(isOdd)
        let borderWidth = self.radius * borderWidthRatio
        for (index, position) in positions.enumerate() {
            if index < self.inputDotCount {
                let pathToFill = UIBezierPath.circlePathWithCenter(position, radius: (radius + borderWidth / 2), lineWidth: borderWidth)
                pathToFill.fill()
            } else {
                let pathToStroke = UIBezierPath.circlePathWithCenter(position, radius: radius, lineWidth: borderWidth)
                pathToStroke.stroke()
            }
        }
    }
    
    //MARK: LifeCycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.updateRadius()
        self.setNeedsDisplay()
    }
    
    //MARK: Animation
    private var shakeCount = 0
    private var direction = false
    public func shakeAnimationWithCompletion(completion: () -> ()) {
        let maxShakeCount = 5
        let centerX = CGRectGetMidX(self.bounds)
        let centerY = CGRectGetMidY(self.bounds)
        var duration = 0.10
        var moveX: CGFloat = 5
        
        if shakeCount == 0 || shakeCount == maxShakeCount {
            duration *= 0.5
        } else {
            moveX *= 2
        }
        self.shakeAnimation(duration, animation: {
            if !self.direction {
                self.center = CGPoint(x: centerX + moveX, y: centerY)
            } else {
                self.center = CGPoint(x: centerX - moveX, y: centerY)
            }
            }, withCompletion: {
                if self.shakeCount >= maxShakeCount {
                    self.shakeAnimation(duration, animation: {
                        let realCenterX = CGRectGetMidX(self.superview!.bounds)
                        self.center = CGPoint(x: realCenterX, y: centerY)
                        }, withCompletion: {
                            self.direction = false
                            self.shakeCount = 0
                            completion()
                    })
                } else {
                    self.shakeCount += 1
                    self.direction = !self.direction
                    self.shakeAnimationWithCompletion(completion)
                }
        })
    }
}

private extension PasswordDotView {
    //MARK: Animation
    func shakeAnimation(duration: NSTimeInterval, animation: () -> (), withCompletion completion: () -> ()) {
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.01, initialSpringVelocity: 0.35, options: [.CurveEaseInOut], animations: {
            animation()
        }) { _ in
            completion()
        }
    }
    
    //MARK: Update Radius
    func updateRadius() {
        let width = CGRectGetWidth(self.bounds)
        let height = CGRectGetHeight(self.bounds)
        var radius = height / 2 - height / 2 * borderWidthRatio
        let spacing = radius * spacingRatio
        let count = CGFloat(self.totalDotCount)
        let spaceCount = count - 1
        if (count * radius * 2 + spaceCount * spacing > width) {
            radius = floor((width / (count + spaceCount)) / 2)
        } else {
            radius = floor(height / 2);
        }
        self.radius = radius - radius * borderWidthRatio
    }

    //MARK: Dots Layout
    func getDotPositions(isOdd: Bool) -> [CGPoint] {
        let centerX = CGRectGetMidX(self.bounds)
        let centerY = CGRectGetMidY(self.bounds)
        let spacing = self.radius * spacingRatio
        let middleIndex = isOdd ? (self.totalDotCount + 1) / 2 : (self.totalDotCount) / 2
        let offSet = isOdd ? 0 : -(self.radius + spacing / 2)
        let positions: [CGPoint] = (1...self.totalDotCount).map { index in
            let i = CGFloat(middleIndex - index)
            let positionX = centerX - (self.radius * 2 + spacing) * i + offSet
            return CGPoint(x: positionX, y: centerY)
        }
        return positions
    }
}

extension UIBezierPath {
    class func circlePathWithCenter(center: CGPoint, radius: CGFloat, lineWidth: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2.0 * CGFloat(M_PI), clockwise: false)
        path.lineWidth = lineWidth
        return path
    }
}
