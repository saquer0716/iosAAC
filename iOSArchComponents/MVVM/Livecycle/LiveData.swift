//
//  LiveData.swift
//  Punch
//
//  Created by Ning Gu on 24/3/19.
//  Copyright © 2019 PunchToday. All rights reserved.
//

import Foundation

enum LiveDataConstant {
    static let START_VERSION = -1
}

class LiveData<T: Any> {
    private var observers = [Observer<T>: ObserverWrapper]()
    
    private var version: Int = LiveDataConstant.START_VERSION
    var activeCount = 0
    private var isDispatchingValue = false
    private var isDispatchInvalidated = false
    
    var data: T! = nil {
        didSet {
            print("LiveData is set")
            version += 1
            dispatchValue(initiator: nil)
        }
    }
    
    func dispatchValue(initiator: ObserverWrapper?) {
        guard !isDispatchingValue else {
            isDispatchInvalidated = true
            return
        }
        
        isDispatchingValue = true
        
        repeat {
            isDispatchInvalidated = false
            
            if let initiatedObserver = initiator {
                considerNotify(wrapper: initiatedObserver)
            } else {
                for (_, observerWrapper) in observers {
                    considerNotify(wrapper: observerWrapper)
                    
                    if isDispatchInvalidated {
                        break
                    }
                }
            }
            
        } while isDispatchInvalidated
        
        isDispatchingValue = false
    }
    
    private func considerNotify(wrapper: ObserverWrapper) {
        guard wrapper.isActive, wrapper.lastVersion < version else {
            print("Observer wrapper not active or data not updated, don't notify")
            return
        }
        
        if !wrapper.shouldBeActive() {
            print("LifeCycle is not appeared, don't notify")
            wrapper.activeStateChanged(false)
            return
        }
        
        wrapper.lastVersion = version
        DispatchQueue.main.async {
            print("LiveData dispatch")
            wrapper.observer.onChanged(self.data)
        }
    }
    
    func observe(owner: LifecycleOwner, _ observer: Observer<T>) {
        if owner.getLifecycle().getCurrentState() == .DESTROYED {
            return
        }
        
        let wrapper = LifecycleBoundObserver(owner, observer, self)
        let existing = putObserverIfAbsent(observer: observer, observerWrapper: wrapper)
        
        if (existing != nil && !existing!.isAttachedTo(owner: owner)) {
            fatalError("Cannot add the same observer with different lifecycles")
        }
    
        if (existing != nil) {
            return
        }
        
        owner.getLifecycle().addObserver(observer: wrapper)
    }
    
    func putObserverIfAbsent(observer: Observer<T>, observerWrapper: ObserverWrapper) -> ObserverWrapper? {
        if let wrapper = observers[observer] {
            return wrapper
        } else {
            observers[observer] = observerWrapper
        }
        
        return nil
    }
    
    func removeObserver(_ observer: Observer<T>) {
        if let removed = observers.removeValue(forKey: observer) {
            removed.detachObserver()
            removed.activeStateChanged(false)
        }
    }
    
    func removeObserver(owner: LifecycleOwner) {
        for (observer, _) in observers {
            removeObserver(observer)
        }
    }
    
    func onActive() {
        
    }
    
    func onInactive() {
        
    }
    
    class ObserverWrapper: LifecycleObserver {
        weak var lifecycleOwner: LifecycleOwner?
        let observer: Observer<T>
        weak var observed: LiveData<T>?
        var isActive: Bool = false
        var lastVersion = LiveDataConstant.START_VERSION
        
        init(_ lifeCycleOwner: LifecycleOwner, _ observer: Observer<T>, _ observed: LiveData<T>) {
            self.lifecycleOwner = lifeCycleOwner
            self.observer = observer
            self.observed = observed
        }
        
        func shouldBeActive() -> Bool { return false }
        
        func isAttachedTo(owner: LifecycleOwner) -> Bool {
            return false
        }
        
        // called by livedata self
        func activeStateChanged(_ newActive: Bool) {
            guard let liveData = observed, newActive != isActive else { return }
            isActive = newActive
            
            let wasInactive = liveData.activeCount == 0
            
            liveData.activeCount += isActive ? 1 : -1
            
            if wasInactive && isActive {
                liveData.onActive()
            }
            
            if liveData.activeCount == 0 && !isActive {
                liveData.onInactive()
            }
            
            if isActive {
                liveData.dispatchValue(initiator: self)
            }
        }
        
        func detachObserver() {
            
        }
    }
    
    class LifecycleBoundObserver: ObserverWrapper {
        override func shouldBeActive() -> Bool {
            guard let owner = lifecycleOwner else { return false }
            return owner.getLifecycle().getCurrentState() == .ACTIVE
        }
        
        override func isAttachedTo(owner: LifecycleOwner) -> Bool {
            return lifecycleOwner === owner
        }
        
        override func detachObserver() {
            guard let owner = lifecycleOwner else { return }
            print("Lifecycle observer removed")
            owner.getLifecycle().removeObserver(observer: self)
        }
        
        // called by lifecycle object
        override func onStateChanged(source: LifecycleOwner, event: Event) {
            guard let owner = lifecycleOwner else { return }
            
            print("onStateChanged, current state is \(owner.getLifecycle().getCurrentState())")
            if (owner.getLifecycle().getCurrentState() == .DESTROYED) {
                print("LiveData observer removed")
                observed?.removeObserver(observer)
                return
            }
            activeStateChanged(shouldBeActive())
        }
        
        override func onLifecycleOwnerDestroyed() {
            print("LiveData observer removed")
            observed?.removeObserver(observer)
        }
    }
}
