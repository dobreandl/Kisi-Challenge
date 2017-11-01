//
//  CALayerShape+Extension.swift
//  Receiver
//
//  Created by Dobrean Dragos on 01/11/2017.
//  Copyright © 2017 appssemble. All rights reserved.
//

import UIKit

extension CAShapeLayer {
    
    func addSpringEffect() {
        let spring = CASpringAnimation(keyPath: "position.y")
        spring.damping = 5
        spring.fromValue = self.position.y
        spring.toValue = self.position.y + 5
        spring.duration = spring.settlingDuration
        
        self.add(spring, forKey: nil)
    }
}
