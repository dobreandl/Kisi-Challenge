//
//  UnlockService.swift
//  Receiver
//
//  Created by Dobrean Dragos on 31/10/2017.
//  Copyright © 2017 appssemble. All rights reserved.
//

import Foundation
import CoreLocation

protocol UnlockServiceDelegate: class {
    func unlockServiceDidUnlockDoorWithBeacon(_ service: UnlockService, beacon: CLBeacon)
    func unlockServiceDidFailToUnlockDoorWithBeacon(_ service: UnlockService, beacon: CLBeacon)
    func unlockServiceBeaconOutOfRange(_ service: UnlockService, beacon: CLBeacon)
}

class UnlockService: BeaconDiscoveryServiceDelegate {
    weak var delegate: UnlockServiceDelegate?
    
    private let doorUnlockService = DoorUnlockService()
    private let beaconDiscoveryService = BeaconDiscoveryService()
    private var inRangeDevices = Set<String>()
    
    private struct Constants {
        static let doorUnlockInterval: TimeInterval = 4
    }
    
    private var timersForBeaconsIDS = [String: Timer]()
    
    // MARK: Lifecycle
    
    init() {
        beaconDiscoveryService.delegate = self
        beaconDiscoveryService.startSearching()
    }
    
    // MARK: Public methods
    
    func unlockDoorForBeacon(_ beacon: Beacon) {
        beaconDiscoveryService.addBeaconForSearch(beacon)
    }
    
    // MARK: Beacon Discovery delegate
    
    func beaconDiscoveryServiceFoundNerbyBeacon(_ service: BeaconDiscoveryService, beacon: CLBeacon) {
        handleInRangeBeacon(beacon)
    }
    
    func beaconDiscoveryServiceBeaconExitNearbyRange(_ service: BeaconDiscoveryService, beacon: CLBeacon) {
        
        handleOutOfRangeBeacon(beacon)
    }
    
    // MARK: Private methods
    
    private func handleInRangeBeacon(_ beacon: CLBeacon) {
        let beaconID = beacon.uniqueID()
        
        addBeaconToInRangeDevices(beacon)
        
        if timersForBeaconsIDS[beaconID] != nil {
            // Do nothing if the timer already exists
            return
        }
        
        DispatchQueue.main.async {
            // Make the initial call
            self.makeUnlockDoorCall(beacon)
            
            // Otherwise create a new timer and add it to the dictionary
            let timer = Timer.scheduledTimer(withTimeInterval: Constants.doorUnlockInterval, repeats: true) { (_) in
                self.makeUnlockDoorCall(beacon)
            }
            
            self.timersForBeaconsIDS[beaconID] = timer
        }
    }
    
    private func handleOutOfRangeBeacon(_ beacon: CLBeacon) {
        let beaconID = beacon.uniqueID()
        
        removeBeaconFromInRangeDevices(beacon)
        
        if let timer = timersForBeaconsIDS[beaconID] {
            timer.invalidate()
            
            timersForBeaconsIDS.removeValue(forKey: beaconID)
        }
        
        DispatchQueue.main.async {
            self.delegate?.unlockServiceBeaconOutOfRange(self, beacon: beacon)
        }
    }
    
    private func makeUnlockDoorCall(_ beacon: CLBeacon) {
        doorUnlockService.unlockDoor(beacon: beacon) { (success) in
            if self.isBeaconInRange(beacon) {
                DispatchQueue.main.async {
                    if success {
                        self.delegate?.unlockServiceDidUnlockDoorWithBeacon(self, beacon: beacon)
                    } else {
                        self.delegate?.unlockServiceDidFailToUnlockDoorWithBeacon(self, beacon: beacon)
                    }
                }
            }
        }
    }
    
    private func isBeaconInRange(_ beacon:CLBeacon) -> Bool {
        let id = beacon.uniqueID()
        var inRange = false
        
        objc_sync_enter(self)
        inRange = inRangeDevices.contains(id)
        objc_sync_exit(self)
        
        return inRange
    }
    
    private func addBeaconToInRangeDevices(_ beacon:CLBeacon) {
        let id = beacon.uniqueID()
        
        objc_sync_enter(self)
        inRangeDevices.insert(id)
        objc_sync_exit(self)
    }
    
    private func removeBeaconFromInRangeDevices(_ beacon:CLBeacon) {
        let id = beacon.uniqueID()
        
        objc_sync_enter(self)
        inRangeDevices.remove(id)
        objc_sync_exit(self)
    }
}

