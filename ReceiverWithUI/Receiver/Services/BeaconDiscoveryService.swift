//
//  BeaconDiscoveryService.swift
//  Receiver
//
//  Created by Dobrean Dragos on 31/10/2017.
//  Copyright © 2017 appssemble. All rights reserved.
//

import Foundation
import CoreLocation

protocol BeaconDiscoveryServiceDelegate: class {
    func beaconDiscoveryServiceFoundNerbyBeacon(_ service: BeaconDiscoveryService, beacon: CLBeacon)
    func beaconDiscoveryServiceBeaconExitNearbyRange(_ service: BeaconDiscoveryService, beacon: CLBeacon)
}

class BeaconDiscoveryService: NSObject, CLLocationManagerDelegate {
    
    weak var delegate: BeaconDiscoveryServiceDelegate?
    
    private var locationManager: CLLocationManager
    private var beacons = [Beacon]()
    
    override init() {
        locationManager = CLLocationManager()
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        
        super.init()
        
        locationManager.delegate = self
    }
    
    func addBeaconForSearch(_ beacon: Beacon) {
        beacons.append(beacon)
        
        // If its already authorized search for the current beacon
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            searchForBeacon(beacon)
        }
    }
    
    func stopSearchForAllBeacons() {
        beacons.forEach { (beacon) in
            stopSearchForBeacon(beacon)
        }
    }
    
    func startSearching() {
        locationManager.requestAlwaysAuthorization()
    }
    
    // MARK: Location manager delegate
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {

        DispatchQueue.global(qos: .background).async {
            // If beacons found, handle them
            if beacons.count > 0 {
                beacons.forEach({ (beacon) in
                    self.handleBeacon(beacon)
                })
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // If we are authorized search for beacons
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        locationManager.startRangingBeacons(in: region as! CLBeaconRegion)
        locationManager.startUpdatingLocation()
    }
    
    // MARK: Private methods
    
    private func searchForBeacon(_ beacon: Beacon) {
        if let region = beacon.beaconRegion() {
            region.notifyEntryStateOnDisplay = true
            region.notifyOnExit = true
            region.notifyOnEntry = true
            
            locationManager.startMonitoring(for: region)
            locationManager.startRangingBeacons(in: region)
            locationManager.startUpdatingLocation()
        }
    }
    
    private func stopSearchForBeacon(_ beacon: Beacon) {
        if let region = beacon.beaconRegion() {
            locationManager.stopRangingBeacons(in: region)
        }
    }
    
    private func startScanning() {
        beacons.forEach { (beacon) in
            searchForBeacon(beacon)
        }
    }
    
    private func handleBeacon(_ beacon: CLBeacon) {
        if beacon.proximity == .immediate {
            // The beacon is ~50cm
            delegate?.beaconDiscoveryServiceFoundNerbyBeacon(self, beacon: beacon)
        } else {
            delegate?.beaconDiscoveryServiceBeaconExitNearbyRange(self, beacon: beacon)
        }
    }
}
