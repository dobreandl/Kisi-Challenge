//
//  Beacon.swift
//  Receiver
//
//  Created by Dobrean Dragos on 31/10/2017.
//  Copyright © 2017 appssemble. All rights reserved.
//

import Foundation
import CoreLocation

struct Beacon {
    let uuid: String
    let major: UInt16
    let minor: UInt16
    let identifier: String
    
    func beaconRegion() -> CLBeaconRegion? {
        if let uuid = UUID(uuidString: uuid) {
            let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: identifier)
            
            return beaconRegion
        }
        
        return nil
    }
}

extension Beacon: Equatable {
    // MARK: Equatable
    
    static func ==(lhs: Beacon, rhs: Beacon) -> Bool {
        return lhs.uuid == rhs.uuid && lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.identifier == rhs.identifier
    }
}
