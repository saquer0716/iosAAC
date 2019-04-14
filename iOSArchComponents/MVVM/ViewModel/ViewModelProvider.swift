//
//  ViewModelProvider.swift
//  Punch
//
//  Created by Ning Gu on 24/3/19.
//  Copyright © 2019 PunchToday. All rights reserved.
//

import Foundation

protocol Factory {
    func create<T: ViewModel>(viewModelType: T.Type) -> T
}

class ViewModelProvider {
    private var factory: Factory = ViewModelFactory.shared
    private var viewModelStore = ViewModelStore.shared
    
    func get<T: ViewModel>(_ key: String, _ viewModelType: T.Type) -> T {
        var viewModel = viewModelStore.get(key: key)
        if let existingViewModel = viewModel as? T {
            return existingViewModel
        }
        
        viewModel = factory.create(viewModelType: viewModelType)
        viewModelStore.put(key: key, viewModel: viewModel!)
        
        return viewModel as! T
    }
    
    func get<T: ViewModel>(_ viewModelType: T.Type) -> T {
        return get(String(describing: viewModelType), viewModelType)
    }
    
    struct ViewModelFactory: Factory {
        static var shared: ViewModelFactory = ViewModelFactory()
        
        private init() {}
        
        func create<T: ViewModel>(viewModelType: T.Type) -> T {
            return viewModelType.init()
        }
    }
}


