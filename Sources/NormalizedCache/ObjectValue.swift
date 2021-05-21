//
//  File.swift
//  
//
//  Created by BJ Beecher on 5/16/21.
//

import Foundation

final class ObjectValue {
    var value : Value
    
    init(value: Value) {
        self.value = value
    }
    
    convenience init(json: [String : Any]){
        self.init(value: .init(json: json))
    }
}

// API

extension ObjectValue {
    func update(with json: [String : Any]){
        value.json.merge(json) { old, new in new }
    }
}

// types

extension ObjectValue {
    struct Value {
        var json : [String : Any]
        let createdDt = Date()
    }
}
