//
//  PreAuthViewController.swift
//  Punch
//
//  Created by Ning Gu on 31/3/19.
//  Copyright © 2019 PunchToday. All rights reserved.
//

import UIKit

class PreAuthViewController: UIViewController {
    static func instantiate(delegate: PreAuthDelegate) -> PreAuthViewController {
        let sb = UIStoryboard(name: "PreAuthViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! PreAuthViewController
        vc.delegate = delegate
        return vc
    }
    
    weak var delegate: PreAuthDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.delegate?.onPreAuthCompleted(true)
        }
    }
}
