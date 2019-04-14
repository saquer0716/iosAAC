//
//  LiveCycleObserver.swift
//  Punch
//
//  Created by Ning Gu on 25/3/19.
//  Copyright © 2019 PunchToday. All rights reserved.
//

import Foundation

class LifecycleObserver: Hashable {
    static func ==(lhs: LifecycleObserver, rhs: LifecycleObserver) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
    
    func onStateChanged(source: LifecycleOwner, event: Event) {
        
    }
    
    func onLifecycleOwnerDestroyed() {
        
    }
}
