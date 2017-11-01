//
//  ViewController.swift
//  Receiver
//
//  Created by Dobrean Dragos on 31/10/2017.
//  Copyright © 2017 appssemble. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UnlockServiceDelegate {
    
    @IBOutlet weak var statusLabel: UILabel!
    
    private let hardCodedBeacon = Beacon(uuid: "68753A44-4D6F-1226-9C60-0050E4C00067", major: 123, minor: 456, identifier: "placeholder")
    
    
    private let unlockService = UnlockService()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        unlockService.delegate = self
        unlockService.unlockDoorForBeacon(hardCodedBeacon)
    }

    // MARK: Unlock Service Delegate
    
    func unlockServiceDidUnlockDoorWithBeacon(_ service: UnlockService, beacon: CLBeacon) {
        

        let message = "Door was unlocked"
        print(message)
        statusLabel.text = message
    }
    
    func unlockServiceDidFailToUnlockDoorWithBeacon(_ service: UnlockService, beacon: CLBeacon) {
        let message = "Fail to unlock the door"
        print(message)
        statusLabel.text = message
    }
    
    func unlockServiceBeaconOutOfRange(_ service: UnlockService, beacon: CLBeacon) {
        let message = "Out of range"
        print(message)
        statusLabel.text = message
    }
    
}

