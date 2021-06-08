//
//  File.swift
//  
//
//  Created by BJ Beecher on 6/8/21.
//

import Foundation

final class Object {
    @Published var value : [String : Any]
    
    init(value: [String : Any]){
        self.value = value
    }
}

// API

extension Object {
    func update(with newValue: [String : Any]){
        let merged = value.merging(newValue) { old, new in new }
        value = merged
    }
}
