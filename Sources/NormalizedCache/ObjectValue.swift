//
//  File.swift
//  
//
//  Created by BJ Beecher on 5/16/21.
//

import Foundation

final class ObjectValue : Codable {
    
    var value : Value
    
    init(value: Value) {
        self.value = value
    }
    
    convenience init(object: [String : Any]) throws {
        let data = try JSONSerialization.data(withJSONObject: object, options: [])
        self.init(value: .init(data: data))
    }
}

// API

extension ObjectValue {
    func getJSON() throws -> [String : JSONObject]? {
        try JSONSerialization.jsonObject(with: value.data, options: [.fragmentsAllowed]) as? [String : JSONObject]
    }
    
    func update(with newObject: [String : JSONObject]) throws {
        if let object = try getJSON() {
            let merged = object.merging(newObject) { old, new in new }
            let data = try JSONSerialization.data(withJSONObject: merged, options: [])
            value.data = data
        } else {
            let data = try JSONSerialization.data(withJSONObject: newObject, options: [])
            value.data = data
        }
    }
}

// types

extension ObjectValue {
    struct Value : Codable, Equatable {
        var data : Data
        let createdDt : Date
        
        init(data: Data){
            self.data = data
            self.createdDt = Date()
        }
    }
}

// conformance

extension ObjectValue : Equatable {
    static func == (lhs: ObjectValue, rhs: ObjectValue) -> Bool {
        lhs.value.data == rhs.value.data
    }
}
