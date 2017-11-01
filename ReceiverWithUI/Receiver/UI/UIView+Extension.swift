//
//  UIView+Extension.swift
//  Receiver
//
//  Created by Dobrean Dragos on 01/11/2017.
//  Copyright © 2017 appssemble. All rights reserved.
//

import UIKit

typealias simpleBlock = () -> Void

extension UIView {
    
    func animate(duration: Double, animationBlock: simpleBlock, completion: simpleBlock?) {
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {
            completion?()
        }
        
        CATransaction.setAnimationDuration(duration)
        
        animationBlock()
        
        CATransaction.commit()
    }
}
