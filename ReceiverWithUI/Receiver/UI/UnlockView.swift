//
//  UnlockView.swift
//  Receiver
//
//  Created by Dobrean Dragos on 31/10/2017.
//  Copyright © 2017 appssemble. All rights reserved.
//

import UIKit

class UnlockView: UIView {
    private var lockUpperPartShapeLayer: CAShapeLayer!
    private var lockLowerPartShapeLayer: CAShapeLayer!
    private var lockBoltMovementShapeLayer: CAShapeLayer!
    private var lockBoltShapeLayer: CAShapeLayer!

    private struct Constants {
        static let lockBarHeight: CGFloat = 70
        static let lockBarWidth: CGFloat = 20
        static let lineWidth: CGFloat = 5
        static let keyRectWidth: CGFloat = 40
        static let keyRectHeight: CGFloat = 20
        static let cornerRadius: CGFloat = 15
        static let boltRadius: CGFloat = 12
        
        static let animationDuration: Double = 1
        
        static let fillColor = UIColor.colorFromString("#FE5E51")
    }
    
    // Set this to change the appearance of the lock
    var locked = true {
        didSet {
            animateToNewState()
        }
    }
    
    // MARK: Lifecycle
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        createLockUpperPart(rect)
        createLockLowerPart(rect)
        createLockBoltMovement(rect)
        createBolt(rect)
    }
    
    // MARK: Private methods
    
    private func animateToNewState() {
        DispatchQueue.main.async {
            if self.locked {
                self.rotateUpperPart(degrees: 0)
                self.moveBolt(locked: true)
            } else {
                self.rotateUpperPart(degrees: 30)
                self.moveBolt(locked: false)
            }
        }
    }
    
    // Moves the bolt to lock/unlock position
    private func moveBolt(locked: Bool = false) {
        animate(duration: Constants.animationDuration / 2, animationBlock: {
            var transform = CATransform3DIdentity
            transform = CATransform3DScale(transform, 1.2, 1, 1)
            lockBoltShapeLayer.transform = transform
            
            if !locked {
                lockBoltShapeLayer.fillColor = UIColor.white.cgColor
            } else {
                lockBoltShapeLayer.fillColor = Constants.fillColor.cgColor
            }
            
            transform = CATransform3DIdentity
            
            if !locked {
                transform = CATransform3DTranslate(transform, 0, 0, 0)
                transform = CATransform3DTranslate(transform, Constants.keyRectWidth, 0, 0)
            }
            
            self.lockBoltShapeLayer.transform = transform
        }, completion: nil)
    }
    
    // Rotates the upper part of the lock
    private func rotateUpperPart(degrees: Int) {
       lockUpperPartShapeLayer.removeAllAnimations()

        var transform = CATransform3DIdentity
        
        let center = CGPoint(x: (bounds.width / 2) - Constants.lockBarHeight, y: 0)
        let rotationPoint = CGPoint(x: (bounds.width / 2) + Constants.lockBarHeight - (Constants.lockBarWidth / 2), y: Constants.lockBarHeight)
    
        transform = CATransform3DTranslate(transform,rotationPoint.x - center.x, rotationPoint.y - center.y, 0.0)
        transform = CATransform3DRotate(transform, degrees.degreesToRadians, 0.0, 0.0, 1.0)
        transform = CATransform3DTranslate(transform,   center.x - rotationPoint.x, center.y-rotationPoint.y, 0)
        
        self.animate(duration: Constants.animationDuration, animationBlock: {
            self.lockUpperPartShapeLayer.transform = transform
        }) {
            if degrees > 0 {
                self.lockUpperPartShapeLayer.addSpringEffect()
            }
        }
    }
    
    // MARK: Creating methods
    
    private func createLockLowerPart(_ rect: CGRect) {
        if let layer = lockLowerPartShapeLayer {
            layer.removeFromSuperlayer()
        }
        
        let lockRect = CGRect(x: 0, y: Constants.lockBarHeight, width: rect.width, height: rect.height - Constants.lockBarHeight)
    
         let lockPath = UIBezierPath(roundedRect: lockRect, cornerRadius: Constants.cornerRadius)
        
        lockLowerPartShapeLayer = CAShapeLayer()
        lockLowerPartShapeLayer.path = lockPath.cgPath
        setDefaultProperiesToLayer(lockLowerPartShapeLayer)
        
        lockLowerPartShapeLayer.fillColor = Constants.fillColor.cgColor
        
        layer.addSublayer(lockLowerPartShapeLayer)
    }
    
    private func createLockBoltMovement(_ rect: CGRect) {
        if let layer = lockBoltMovementShapeLayer {
            layer.removeFromSuperlayer()
        }
        
        let keyRect = CGRect(x: (rect.width / 2) - (Constants.keyRectWidth / 2), y: rect.height - ((rect.height - Constants.lockBarHeight) / 2) - (Constants.keyRectHeight / 2), width: Constants.keyRectWidth, height: Constants.keyRectHeight)
        
        let keyPath = UIBezierPath(roundedRect: keyRect, cornerRadius: Constants.cornerRadius)
        
        lockBoltMovementShapeLayer = CAShapeLayer()
        lockBoltMovementShapeLayer.path = keyPath.cgPath
        setDefaultProperiesToLayer(lockBoltMovementShapeLayer)
        
        layer.addSublayer(lockBoltMovementShapeLayer)
    }
    
    private func createBolt(_ rect: CGRect) {
        if let layer = lockBoltShapeLayer {
            layer.removeFromSuperlayer()
        }
        
        let boltCenter = CGPoint(x: (rect.width / 2) - (Constants.keyRectWidth / 2), y: rect.height - ((rect.height - Constants.lockBarHeight) / 2) )
        
        let roundPath = UIBezierPath(arcCenter: boltCenter, radius: Constants.boltRadius, startAngle: 0.degreesToRadians, endAngle: 360.degreesToRadians, clockwise: true)
        
        lockBoltShapeLayer = CAShapeLayer()
        lockBoltShapeLayer.path = roundPath.cgPath
        setDefaultProperiesToLayer(lockBoltShapeLayer)
        
        lockBoltShapeLayer.fillColor = Constants.fillColor.cgColor
        
        layer.addSublayer(lockBoltShapeLayer)
    }
    
    private func createLockUpperPart(_ rect: CGRect) {
        if let layer = lockUpperPartShapeLayer {
            layer.removeFromSuperlayer()
        }
        
        let lockUpperPartPath = UIBezierPath()
        
        addCirclesPaths(path: lockUpperPartPath, rect: rect)
        addCirclesUnionLinePaths(path: lockUpperPartPath, rect: rect)
        
        lockUpperPartShapeLayer = CAShapeLayer()
        lockUpperPartShapeLayer.path = lockUpperPartPath.cgPath
        setDefaultProperiesToLayer(lockUpperPartShapeLayer)
        
        layer.addSublayer(lockUpperPartShapeLayer)
    }
    
    private func addCirclesPaths(path: UIBezierPath, rect: CGRect) {
        let arcCenter = CGPoint(x: rect.width / 2, y: Constants.lockBarHeight)
        
        // Create two circles
        let upperSemiCirclePath = UIBezierPath(arcCenter: arcCenter, radius: Constants.lockBarHeight, startAngle: 180.degreesToRadians, endAngle: 0.degreesToRadians, clockwise: true)
        
        path.append(upperSemiCirclePath)
        
        let lowerSemiCirclePath = UIBezierPath(arcCenter: arcCenter, radius: Constants.lockBarHeight - Constants.lockBarWidth, startAngle: 180.degreesToRadians, endAngle: 0.degreesToRadians, clockwise: true)
        
        path.append(lowerSemiCirclePath)
    }
    
    private func addCirclesUnionLinePaths(path: UIBezierPath, rect: CGRect) {
        // Create line between them
        let unionLinePath = UIBezierPath()
        let leftUnionLinePoint = CGPoint(x: rect.width / 2 - Constants.lockBarHeight - (Constants.lineWidth / 2), y: Constants.lockBarHeight)
        let leftUnionLinePointFinish = CGPoint(x: (rect.width / 2 - Constants.lockBarHeight) + Constants.lockBarWidth + (Constants.lineWidth / 2), y: Constants.lockBarHeight)
        
        unionLinePath.move(to: leftUnionLinePoint)
        unionLinePath.addLine(to: leftUnionLinePointFinish)
        
        let rightUnionLinePoint = CGPoint(x: (rect.width / 2) + Constants.lockBarHeight, y: Constants.lockBarHeight)
        let rightUnionLinePointFinish = CGPoint(x: (rect.width / 2 + Constants.lockBarHeight) - Constants.lockBarWidth, y: Constants.lockBarHeight)
        
        unionLinePath.move(to: rightUnionLinePoint)
        unionLinePath.addLine(to: rightUnionLinePointFinish)
        
        path.append(unionLinePath)
    }
    
    // MARK: Properties of the layers
    
    private func setDefaultProperiesToLayer(_ layer: CAShapeLayer) {
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = Constants.lineWidth
    }
}
