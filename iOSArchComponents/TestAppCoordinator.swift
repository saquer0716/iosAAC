//
//  TestAppCoordinator.swift
//  Punch
//
//  Created by Ning Gu on 28/3/19.
//  Copyright © 2019 PunchToday. All rights reserved.
//

import Foundation
import UIKit

protocol AppFlowPreAuth {
    func onAuthenticationComplete(isAuthenticated: Bool)
}

protocol AppFlowRegistration {
    func onRegistrationComplete()
}

protocol AppFlowLogIn {
    func onLogIn()
}

class TestAppCoordinator: ApplicationCoordiantor {
    private let window: UIWindow
    
    private var navigator: RootContainerViewController!
    
    private var mainCoordinator: MainCoordinator!
    private var registrationCoordinator: RegistrationCoordinator!
//    private var logInCoordinator: LogInCoordinator!

    required init(window: UIWindow) {
        self.window = window
        self.navigator = RootContainerViewController(appCoordinator: self)
        self.window.rootViewController = self.navigator
        // further configuration on RootContainerViewController
    }
    
    func start() {
        window.makeKeyAndVisible()
    }
    
    private func startMainFlow() {
        if self.mainCoordinator == nil {
            self.mainCoordinator = MainCoordinator()
        }
        
        navigator.startNewFlow(new: self.mainCoordinator)
    }
    
    private func startRegistrationFlow() {
        if self.registrationCoordinator == nil {
            self.registrationCoordinator = RegistrationCoordinator(with: self)
        }
        
        navigator.presentNewFlow(new: self.registrationCoordinator)
    }
}

extension TestAppCoordinator: AppFlowPreAuth {
    func onAuthenticationComplete(isAuthenticated: Bool) {
        if isAuthenticated {
            startMainFlow()
        } else {
            startRegistrationFlow()
        }
    }
}

extension TestAppCoordinator: AppFlowRegistration {
    func onRegistrationComplete() {
        startMainFlow()
    }
}
