//
//  File.swift
//  
//
//  Created by BJ Beecher on 5/17/21.
//

import Foundation

protocol ComposerInterface {
    @discardableResult func decompose(_ object: JSONObject) throws -> JSONObject
    func recompose(_ object: JSONObject) throws -> JSONObject
}

// conformance

final class Composer : ComposerInterface {
    var store : ObjectStoreInterface
    
    init(store : ObjectStoreInterface = [String : ObjectValue]()){
        self.store = store
    }
}

// public API

extension Composer {
    @discardableResult
    func decompose(_ json: JSONObject) throws -> JSONObject {
        if let object = json as? [String : JSONObject] {
            let flattenedObject = try object.mapValues(decompose)
            
            if let key = key(for: object) {
                try save(flattenedObject, for: key)
                return key
            } else {
                return flattenedObject
            }
        } else if let objects = json as? [JSONObject] {
            return try objects.map(decompose)
        }
        
        return json // Primitive
    }
    
    func recompose(_ json: JSONObject) throws -> JSONObject {
        if let object = json as? [String: JSONObject] {
            return try object.reduce(into: [:]) { result, item in
                result[item.key] = try recompose(item.value)
            }
        } else if let objects = json as? [JSONObject] {
            return try objects.map(recompose)
        } else if let objectRef = json as? String, objectRef.contains("~>") {
            if let value = store[objectRef], let json = try value.getJSON() {
                return try recompose(json)
            } else {
                throw Failure.recomposition
            }
        }
        
        return json
    }
}

// helper API

extension Composer {
    func key(for object: [String: JSONObject]) -> String? {
        let value = object["id"]
        
        if let string = value as? String, UUID(uuidString: string) != nil {
            return "~>\(string)"
        } else {
            return nil
        }
    }
    
    func save(_ object: [String : JSONObject], for key: String) throws {
        if let current = store[key] {
            try current.update(with: object)
        } else {
            store[key] = try ObjectValue(object: object)
        }
    }
}
