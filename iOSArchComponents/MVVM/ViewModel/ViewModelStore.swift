//
//  ViewModelStore.swift
//  Punch
//
//  Created by Ning Gu on 24/3/19.
//  Copyright © 2019 PunchToday. All rights reserved.
//

import Foundation

class ViewModelStore {
    private var storeMap = Dictionary<String, ViewModel>()
    
    static let shared = ViewModelStore()
    
    private init() {}
    
    func put(key: String, viewModel: ViewModel) {
        storeMap[key]?.onCleared()
        storeMap[key] = viewModel
    }
    
    func get(key: String) -> ViewModel? {
        return storeMap[key]
    }
    
    // need to call this function in appwillterminate
    func clear() {
        for viewModel in storeMap.values {
            viewModel.onCleared()
        }
        
        storeMap.removeAll()
    }
}
