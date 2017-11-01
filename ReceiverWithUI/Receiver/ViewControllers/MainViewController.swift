//
//  MainViewController.swift
//  Receiver
//
//  Created by Dobrean Dragos on 31/10/2017.
//  Copyright © 2017 appssemble. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, UnlockServiceDelegate {
    private let hardCodedBeacon = Beacon(uuid: "68753A44-4D6F-1226-9C60-0050E4C00067", major: 123, minor: 456, identifier: "placeholder")
    
    @IBOutlet weak var unlockView: UnlockView!
    private let unlockService = UnlockService()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        unlockService.delegate = self
        unlockService.unlockDoorForBeacon(hardCodedBeacon)
    }
    
    // MARK: Unlock Service Delegate
    
    func unlockServiceDidUnlockDoorWithBeacon(_ service: UnlockService, beacon: CLBeacon) {
        unlockView.locked = false
    }
    
    func unlockServiceDidFailToUnlockDoorWithBeacon(_ service: UnlockService, beacon: CLBeacon) {
        unlockView.locked = true
    }
    
    func unlockServiceBeaconOutOfRange(_ service: UnlockService, beacon: CLBeacon) {
        unlockView.locked = true
    }
}

