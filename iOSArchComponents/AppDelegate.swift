//
//  AppDelegate.swift
//  NewArch
//
//  Created by Ning Gu on 9/4/19.
//  Copyright © 2019 Ning Gu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var applicationCoordinator: TestAppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        self.applicationCoordinator = TestAppCoordinator(window: window)
        self.applicationCoordinator.start()
        
        return true
    }
}

extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}
