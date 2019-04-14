//
//  LifeCycle.swift
//  Punch
//
//  Created by Ning Gu on 25/3/19.
//  Copyright © 2019 PunchToday. All rights reserved.
//

import Foundation

enum State {
    case INACTIVE
    case ACTIVE
    case DESTROYED
    
    static func getEvent(state: State) -> Event {
        switch state {
        case .INACTIVE:
            return .onDisappeard
        case .ACTIVE:
            return .onAppeared
        case .DESTROYED:
            return .onUnload
        }
    }
}

enum Event {
    case onUnload
    case onLoaded
    case onAppeared
    case onDisappeard
    
    static func getStateAfter(event: Event) -> State {
        switch event {
        case .onDisappeard:
            return .INACTIVE
        case .onLoaded, .onAppeared:
            return .ACTIVE
        case .onUnload:
            return .DESTROYED
        }
    }
}

protocol Lifecycle {
    func addObserver(observer: LifecycleObserver)
    func removeObserver(observer: LifecycleObserver)
    
    func getCurrentState() -> State
    func handleLifecycleEvent(event: Event)
}
