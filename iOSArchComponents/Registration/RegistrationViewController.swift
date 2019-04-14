//
//  RegistrationViewController.swift
//  Punch
//
//  Created by Ning Gu on 31/3/19.
//  Copyright © 2019 PunchToday. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    static func instantiate(delegate: RegistrationFlow) -> RegistrationViewController {
        let sb = UIStoryboard(name: "RegistrationViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! RegistrationViewController
        vc.delegate = delegate
        return vc
    }
    
    weak var delegate: RegistrationFlow?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onRegistrationCompleted(_ sender: Any) {
        delegate?.onRegistrationComplete()
    }
}
