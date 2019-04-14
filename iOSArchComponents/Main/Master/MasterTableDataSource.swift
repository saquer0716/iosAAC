//
//  MasterTableDataSource.swift
//  Punch
//
//  Created by Ning Gu on 29/3/19.
//  Copyright © 2019 PunchToday. All rights reserved.
//

import Foundation
import UIKit

class MasterTableDataSource: NSObject, UITableViewDataSource {
    private weak var tableView: UITableView?
    
    private var dataSource: Array<String> {
        didSet {
            self.tableView?.reloadData()
        }
    }
    
    init(_ tableView: UITableView, _ dataSource: Array<String> = []) {
        self.tableView = tableView
        self.dataSource = dataSource
    }
    
    func updateData(_ dataSource: Array<String>) {
        self.dataSource = dataSource
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
        
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
}
