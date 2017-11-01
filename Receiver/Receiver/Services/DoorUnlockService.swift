//
//  DoorUnlockService.swift
//  Receiver
//
//  Created by Dobrean Dragos on 31/10/2017.
//  Copyright © 2017 appssemble. All rights reserved.
//

import Foundation
import CoreLocation

typealias genericBooleanCompletion = (_ success: Bool) -> Void

class DoorUnlockService {
    private struct Constants {
        static let lockID = "5873"
        static let doorUnlockURL = URL(string: "https://api.getkisi.com/locks/\(lockID)/access")!
        
        static let authorizationHeader = "Authorization"
        static let clientID = "KISI-LINK 75388d1d1ff0dff6b7b04a7d5162cc6c"
    }
    
    func unlockDoor(beacon: CLBeacon, completion: @escaping genericBooleanCompletion) {
        let request = NSMutableURLRequest(url: Constants.doorUnlockURL)
        
        request.setValue(Constants.clientID, forHTTPHeaderField: Constants.authorizationHeader)
        request.httpMethod = HTTPMethods.POST.rawValue
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let response = response as? HTTPURLResponse {
                let code = response.statusCode
                
                let success = code == 200
                
                DispatchQueue.global(qos: .background).async {
                    completion(success)
                }
            }
        }
        
        task.resume()
    }
    
}

