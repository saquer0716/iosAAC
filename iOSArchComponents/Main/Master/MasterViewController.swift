//
//  MasterViewController.swift
//  Punch
//
//  Created by Ning Gu on 29/3/19.
//  Copyright © 2019 PunchToday. All rights reserved.
//

import UIKit

class MasterViewController: LifeCycleViewController {
    static func instantiate(flow: MainFeatureFlow) -> MasterViewController {
        let vc = MasterViewController(nibName: "MasterViewController", bundle: nil)
        vc.coordinator = flow
        return vc
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var tableDataSource: MasterTableDataSource!
    
    private var viewModel: MasterDetailViewModel!
    private var coordinator: MainFeatureFlow?
    
    private lazy var tableViewDataSourceObserver = Observer<Array<String>> { [weak self] data in
        print("table updated")
        self?.tableDataSource.updateData(data)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
        tableDataSource = MasterTableDataSource(tableView)
        tableView.dataSource = tableDataSource
        tableView.delegate = self
        
        viewModel = ViewModelProvider().get(MasterDetailViewModel.self)
        
        viewModel.liveDataArray.observe(owner: self, tableViewDataSourceObserver)
        viewModel.startLoadingData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}

extension MasterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.setSelectedItem(at: indexPath.row)
        self.coordinator?.onItemSelected()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
