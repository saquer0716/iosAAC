//
//  Observer.swift
//  Punch
//
//  Created by Ning Gu on 27/3/19.
//  Copyright © 2019 PunchToday. All rights reserved.
//

import Foundation

struct Observer<T: Any>: Hashable {
    typealias OnChanged = (T) -> ()

    let onChanged: OnChanged
    
    let observerId: String = UUID().uuidString
    
    init(_ onChanged: @escaping OnChanged) {
        self.onChanged = onChanged
    }
    
    var hashValue: Int {
        return observerId.hashValue
    }
    
    static func == (lhs: Observer<T>, rhs: Observer<T>) -> Bool {
        return lhs.observerId == rhs.observerId
    }
}
