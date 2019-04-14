//
//  ViewModelViewController.swift
//  Punch
//
//  Created by Ning Gu on 24/3/19.
//  Copyright © 2019 PunchToday. All rights reserved.
//

import UIKit

class LifeCycleViewController: UIViewController, LifecycleOwner {
    private lazy var lifecycleRegistry: LifecycleRegistry = {
        return LifecycleRegistry(provider: self)
    }()
    
    func getLifecycle() -> Lifecycle {
        return lifecycleRegistry
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        lifecycleRegistry.handleLifecycleEvent(event: .onLoaded)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lifecycleRegistry.handleLifecycleEvent(event: .onAppeared)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lifecycleRegistry.handleLifecycleEvent(event: .onDisappeard)
    }
    
    deinit {
        lifecycleRegistry.handleLifecycleEvent(event: .onUnload)
    }
}
