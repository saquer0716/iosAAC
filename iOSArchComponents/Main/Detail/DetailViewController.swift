//
//  DetailViewController.swift
//  Punch
//
//  Created by Ning Gu on 29/3/19.
//  Copyright © 2019 PunchToday. All rights reserved.
//

import UIKit

class DetailViewController: LifeCycleViewController {
    static func instantiate(flow: MainFeatureFlow) -> DetailViewController {
        let sb = UIStoryboard(name: "DetailViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! DetailViewController
        vc.coordinator = flow
        return vc
    }
    
    private lazy var selectedDataObserver = Observer<String> { [weak self] data in
        self?.inputText.text = data
    }
    
    @IBOutlet weak var inputText: UITextField!
    
    private var coordinator: MainFeatureFlow?
    
    private var viewModel: MasterDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ViewModelProvider().get(MasterDetailViewModel.self)
        viewModel.liveDataString.observe(owner: self, selectedDataObserver)
    }
    
    @IBAction func onUpdateConfirmed(_ sender: Any) {
        viewModel.updateSelectedItem(inputText.text)
        coordinator?.onItemUpdated()
    }
}
