//
//  PreAuthProtocol.swift
//  Punch
//
//  Created by Ning Gu on 31/3/19.
//  Copyright © 2019 PunchToday. All rights reserved.
//

import Foundation

protocol PreAuthDelegate: class {
    func onPreAuthCompleted(_ hasSession: Bool)
}
