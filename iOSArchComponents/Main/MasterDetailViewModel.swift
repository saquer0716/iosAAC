//
//  ViewControllerViewModel.swift
//  Punch
//
//  Created by Ning Gu on 24/3/19.
//  Copyright © 2019 PunchToday. All rights reserved.
//

import Foundation

class MasterDetailViewModel: ViewModel {
    var liveDataArray = LiveData<Array<String>>()
    var liveDataString = LiveData<String>()
    
    var selectedIndex = -1
    
    required init() {
    }
    
    func startLoadingData() {
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2.0) {
            self.liveDataArray.data = ["1", "2", "3", "4", "5", "6", "7", "8"]
        }
    }
    
    func setSelectedItem(at row: Int) {
        selectedIndex = row
        liveDataString.data = liveDataArray.data[row]
    }
    
    func updateSelectedItem(_ text: String?) {
        guard let updatedText = text else { return }
        
        if updatedText != liveDataString.data {
            liveDataArray.data[selectedIndex] = updatedText
        }
    }
}
