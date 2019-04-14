//
//  RootContainerViewController.swift
//  Punch
//
//  Created by Ning Gu on 31/3/19.
//  Copyright © 2019 PunchToday. All rights reserved.
//

import UIKit

protocol Navigator where Self: UIViewController {
    func startNewFlow(new: FlowCoordinator)
    
    func presentNewFlow(new: FlowCoordinator)
    
    func dismissFlow(flow: FlowCoordinator)
}

class RootContainerViewController: UIViewController {
    var current: UIViewController!
    var appCoordinator: TestAppCoordinator!
    
    init(appCoordinator: TestAppCoordinator) {
        super.init(nibName: nil, bundle: nil)
        
        self.appCoordinator = appCoordinator
        self.current = PreAuthViewController.instantiate(delegate: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
}

extension RootContainerViewController: Navigator {
    func startNewFlow(new: FlowCoordinator) {
        let flowRootVc = new.rootViewController
        addChild(flowRootVc)
        flowRootVc.view.frame = view.bounds
        view.addSubview(flowRootVc.view)
        flowRootVc.didMove(toParent: self)
        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()
        current = flowRootVc
    }
    
    func presentNewFlow(new: FlowCoordinator) {
        present(new.rootViewController, animated: true) {
            self.current = new.rootViewController
        }
        
    }
    
    func dismissFlow(flow: FlowCoordinator) {
        presentedViewController?.dismiss(animated: true, completion: {
            self.current = self.children.last
        })
    }
}

extension RootContainerViewController: PreAuthDelegate {
    func onPreAuthCompleted(_ hasSession: Bool) {
        if let appFlowPreAuth = appCoordinator {
            appFlowPreAuth.onAuthenticationComplete(isAuthenticated: hasSession)
        }
    }
}
