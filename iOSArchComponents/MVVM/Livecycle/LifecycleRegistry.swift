//
//  LiveCycleRegistry.swift
//  Punch
//
//  Created by Ning Gu on 25/3/19.
//  Copyright © 2019 PunchToday. All rights reserved.
//

import Foundation

class LifecycleRegistry {
    var state: State
    private weak var lifecycleOwner: LifecycleOwner?
    private var observers = [LifecycleObserver : ObserverWithState]()

    private var isHandlingEvent = false
    private var isNewEventOccurred = false
    private var addingObserverCounter = 0;
    
    init(provider: LifecycleOwner) {
        lifecycleOwner = provider
        state = .INACTIVE
    }
}

extension LifecycleRegistry: Lifecycle {
    func getCurrentState() -> State {
        return state
    }
    
    func handleLifecycleEvent(event: Event) {
        print("lifecycle event: \(event)")
        let next = Event.getStateAfter(event: event)
        
        if (self.state == next) {
            return
        }
        
        self.state = next
        if (isHandlingEvent) {
            return
        }
        
        isHandlingEvent = true
        sync();
        isHandlingEvent = false
    }
    
    private func isSynced() -> Bool {
        return true
    }
    
    private func sync() {
        guard let owner = lifecycleOwner else {
            removeObservers()
            return
        }
        
        for (_, statedObserver) in observers {
            isNewEventOccurred = false;
            
            // shall the state of statedObserver be considered before dispatching?
            statedObserver.dispatchEvent(owner: owner, event: State.getEvent(state: state))
        }
        
        isNewEventOccurred = false;
    }
    
    private func removeObservers() {
        for (_, statedObserver) in observers {
            statedObserver.removeObserver()
        }
    }
    
    func addObserver(observer: LifecycleObserver) {
        let initialState: State = state == .DESTROYED ? .DESTROYED : .INACTIVE
        
        let statefulObserver = ObserverWithState(registry: self, observer: observer, initialState: initialState)

        // we don't continue if it's existed subscription
        if putObserverIfAbsent(observer: observer, statefulObserver: statefulObserver) != nil {
            return
        }
        
        sync()
    }
    
    private func putObserverIfAbsent(observer: LifecycleObserver, statefulObserver: ObserverWithState) -> ObserverWithState? {
        if let wrapper = observers[observer] {
            return wrapper
        } else {
            observers[observer] = statefulObserver
            return nil
        }
    }
    
    func removeObserver(observer: LifecycleObserver) {
        observers[observer] = nil
    }
    
    class ObserverWithState {
        weak var lifecycleRegistry: LifecycleRegistry?
        var state: State
        let lifecycleObserver: LifecycleObserver
        
        init(registry: LifecycleRegistry, observer: LifecycleObserver, initialState: State) {
            self.lifecycleRegistry = registry
            self.lifecycleObserver = observer
            self.state = initialState;
        }
        
        // this will change state of observer in LiveData to active/inactive
        func dispatchEvent(owner: LifecycleOwner, event: Event) {
            let newState = Event.getStateAfter(event: event)
            self.lifecycleObserver.onStateChanged(source: owner, event: event)
            self.state = newState;
        }
        
        func removeObserver() {
            self.lifecycleObserver.onLifecycleOwnerDestroyed()
        }
    }
}
