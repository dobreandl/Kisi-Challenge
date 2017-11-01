//
//  AppDelegate.swift
//  Receiver
//
//  Created by Dobrean Dragos on 31/10/2017.
//  Copyright © 2017 appssemble. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationDidBecomeActive(_ application: UIApplication) {
       showSplashScreen()
    }

    private func showSplashScreen() {
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "splash")
        self.window!.rootViewController!.present(vc, animated: false, completion: nil)
        
        // Dismiss it after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            vc.dismiss(animated: false, completion: nil)
        }
    }
}

