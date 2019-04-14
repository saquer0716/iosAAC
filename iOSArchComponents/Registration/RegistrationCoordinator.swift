//
//  RegistrationCoordinator.swift
//  Punch
//
//  Created by Ning Gu on 31/3/19.
//  Copyright © 2019 PunchToday. All rights reserved.
//

import Foundation
import UIKit

protocol RegistrationFlow: class {
    func onScreen1()
    func onScreen2()
    func onRegistrationComplete()
}

class RegistrationCoordinator: FlowCoordinator {
    private var rootVC: UIViewController!
    var appCoordinator: TestAppCoordinator!
    
    var rootViewController: UIViewController {
        return rootVC
    }

    init(with appCoordinator: TestAppCoordinator) {
        self.appCoordinator = appCoordinator
        self.rootVC = RegistrationViewController.instantiate(delegate: self)
        
        start()
    }
    
    func start() {
        
    }
}

extension RegistrationCoordinator: RegistrationFlow {
    func onScreen1() {
        
    }
    
    func onScreen2() {
        
    }
    
    func onRegistrationComplete() {
        if let appFlowReg = appCoordinator {
            appFlowReg.onRegistrationComplete()
        }
    }
}
