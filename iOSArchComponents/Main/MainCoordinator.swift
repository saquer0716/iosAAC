//
//  BusinessCoordinator.swift
//  Punch
//
//  Created by Ning Gu on 28/3/19.
//  Copyright © 2019 PunchToday. All rights reserved.
//

import Foundation
import UIKit

protocol MainFeatureFlow {
    func onItemSelected()
    func onItemUpdated()
}

class MainCoordinator: FlowCoordinator, MainFeatureFlow {
    private var rootVC: UINavigationController!
    var masterViewController: MasterViewController!
    
    var rootViewController: UIViewController {
        return rootVC
    }
    
    init() {
        rootVC = UINavigationController()
        
        start()
    }
    
    func start() {
        self.masterViewController = MasterViewController.instantiate(flow: self)
        self.masterViewController.navigationItem.title = "LiveData & ViewModel Test"

        self.rootVC.pushViewController(self.masterViewController, animated: true)
    }
    
    func onItemSelected() {
        let detailViewController = DetailViewController.instantiate(flow: self)
        self.rootVC.pushViewController(detailViewController, animated: true)
    }
    
    func onItemUpdated() {
        self.rootVC.popViewController(animated: true)
    }
}
