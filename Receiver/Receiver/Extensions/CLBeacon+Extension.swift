//
//  CLBeacon+Extension.swift
//  Receiver
//
//  Created by Dobrean Dragos on 31/10/2017.
//  Copyright © 2017 appssemble. All rights reserved.
//

import Foundation
import CoreLocation

extension CLBeacon {
    // Returns an ID that identifies the beacon uniquely
    func uniqueID() -> String {
        return self.proximityUUID.uuidString + "\(major)" + "\(minor)"
    }
}
