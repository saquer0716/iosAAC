//
//  LifeCycleOwner.swift
//  Punch
//
//  Created by Ning Gu on 25/3/19.
//  Copyright © 2019 PunchToday. All rights reserved.
//

import Foundation
import UIKit

protocol LifecycleOwner: AnyObject {
    func getLifecycle() -> Lifecycle
}
