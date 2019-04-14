//
//  Coordiantor.swift
//  Punch
//
//  Created by Ning Gu on 28/3/19.
//  Copyright © 2019 PunchToday. All rights reserved.
//

import Foundation
import UIKit

protocol Coordiantor {
    func start()
}

protocol ApplicationCoordiantor: Coordiantor {
    init(window: UIWindow)
}

/// App business flow coordinator shall implement this protocol and come with its own
/// initilizer to propagate data between coordinators.
protocol FlowCoordinator: Coordiantor {
    var rootViewController: UIViewController { get }
}
