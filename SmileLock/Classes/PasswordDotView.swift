//
//  PasswordDotView.swift
//
//  Created by rain on 4/21/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.
//

import UIKit

@IBDesignable
open class PasswordDotView: UIView {
    
    //MARK: Property
    @IBInspectable
    open var inputDotCount: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    open var totalDotCount: Int = 6 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    open var strokeColor: UIColor = UIColor.darkGray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    open var fillColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }

    fileprivate var radius: CGFloat = 6
    fileprivate let spacingRatio: CGFloat = 2
    fileprivate let borderWidthRatio: CGFloat = 1 / 5
    
    fileprivate(set) open var isFull = false
    
    //MARK: Draw
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        isFull = (inputDotCount == totalDotCount)
        strokeColor.setStroke()
        fillColor.setFill()
        let isOdd = (totalDotCount % 2) != 0
        let positions = getDotPositions(isOdd)
        let borderWidth = radius * borderWidthRatio
        for (index, position) in positions.enumerated() {
            if index < inputDotCount {
                let pathToFill = UIBezierPath.circlePathWithCenter(position, radius: (radius + borderWidth / 2), lineWidth: borderWidth)
                pathToFill.fill()
            } else {
                let pathToStroke = UIBezierPath.circlePathWithCenter(position, radius: radius, lineWidth: borderWidth)
                pathToStroke.stroke()
            }
        }
    }
    
    //MARK: LifeCycle
    open override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateRadius()
        setNeedsDisplay()
    }
    
    //MARK: Animation
    fileprivate var shakeCount = 0
    fileprivate var direction = false
    open func shakeAnimationWithCompletion(_ completion: @escaping () -> ()) {
        let maxShakeCount = 5
        let centerX = bounds.midX
        let centerY = bounds.midY
        var duration = 0.10
        var moveX: CGFloat = 5
        
        if shakeCount == 0 || shakeCount == maxShakeCount {
            duration *= 0.5
        } else {
            moveX *= 2
        }
        shakeAnimation(duration, animation: {
            if !self.direction {
                self.center = CGPoint(x: centerX + moveX, y: centerY)
            } else {
                self.center = CGPoint(x: centerX - moveX, y: centerY)
            }
            }, withCompletion: {
                if self.shakeCount >= maxShakeCount {
                    self.shakeAnimation(duration, animation: {
                        let realCenterX = self.superview!.bounds.midX
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
    func shakeAnimation(_ duration: TimeInterval, animation: @escaping () -> (), withCompletion completion: @escaping () -> ()) {
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.01, initialSpringVelocity: 0.35, options: UIViewAnimationOptions(), animations: {
            animation()
        }) { _ in
            completion()
        }
    }
    
    //MARK: Update Radius
    func updateRadius() {
        let width = bounds.width
        let height = bounds.height
        radius = height / 2 - height / 2 * borderWidthRatio
        let spacing = radius * spacingRatio
        let count = CGFloat(totalDotCount)
        let spaceCount = count - 1
        if (count * radius * 2 + spaceCount * spacing > width) {
            radius = floor((width / (count + spaceCount)) / 2)
        } else {
            radius = floor(height / 2);
        }
        radius = radius - radius * borderWidthRatio
    }

    //MARK: Dots Layout
    func getDotPositions(_ isOdd: Bool) -> [CGPoint] {
        let centerX = bounds.midX
        let centerY = bounds.midY
        let spacing = radius * spacingRatio
        let middleIndex = isOdd ? (totalDotCount + 1) / 2 : (totalDotCount) / 2
        let offSet = isOdd ? 0 : -(radius + spacing / 2)
        let positions: [CGPoint] = (1...totalDotCount).map { index in
            let i = CGFloat(middleIndex - index)
            let positionX = centerX - (radius * 2 + spacing) * i + offSet
            return CGPoint(x: positionX, y: centerY)
        }
        return positions
    }
}

extension UIBezierPath {
    class func circlePathWithCenter(_ center: CGPoint, radius: CGFloat, lineWidth: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2.0 * CGFloat(M_PI), clockwise: false)
        path.lineWidth = lineWidth
        return path
    }
}
