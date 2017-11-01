//
//  ViewController.swift
//  BeaconTransmitter
//
//  Created by Dobrean Dragos on 01/11/2017.
//  Copyright © 2017 appssemble. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

class iBeaconTransmission: NSObject, CBPeripheralManagerDelegate {
    
    var localBeacon: CLBeaconRegion!
    var beaconPeripheralData: NSDictionary!
    var peripheralManager: CBPeripheralManager!
    
    func initLocalBeacon() {
        if localBeacon != nil {
            stopLocalBeacon()
        }
        
        let localBeaconUUID = "68753A44-4D6F-1226-9C60-0050E4C00067"
        let localBeaconMajor: CLBeaconMajorValue = 123
        let localBeaconMinor: CLBeaconMinorValue = 456
        
        let uuid = NSUUID(uuidString: localBeaconUUID)
        
        if let uuid = uuid {
            
            localBeacon = CLBeaconRegion(proximityUUID: uuid as UUID, major: localBeaconMajor, minor: localBeaconMinor, identifier: "placeholder")
            
            self.beaconPeripheralData = self.localBeacon.peripheralData(withMeasuredPower: nil)
            self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        }
    }
    
    func stopLocalBeacon() {
        peripheralManager.stopAdvertising()
        peripheralManager = nil
        beaconPeripheralData = nil
        localBeacon = nil
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("Peripheral Manager")
        if peripheral.state == .poweredOn {
            print("Transmitting")
            peripheralManager.startAdvertising(beaconPeripheralData as! [String: AnyObject]!)
        } else if peripheral.state == .poweredOff {
            peripheralManager.stopAdvertising()
        }
    }
}

class ViewController: UIViewController {
    
    var bc: iBeaconTransmission!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bc = iBeaconTransmission()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bc.initLocalBeacon()
    }
}


