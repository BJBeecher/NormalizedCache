//
//  File.swift
//  
//
//  Created by BJ Beecher on 5/17/21.
//

import Foundation

protocol ComposerInterface {
    @discardableResult func decompose(_ object: Any) -> Any
    func recompose(_ object: Any) throws -> Any
}

// conformance

final class Composer : ComposerInterface {
    var store : ObjectStoreInterface
    
    init(store : ObjectStoreInterface = [ObjectKey : ObjectValue]()){
        self.store = store
    }
}

// public API

extension Composer {
    @discardableResult
    func decompose(_ object: Any) -> Any {
        if let object = object as? [String: Any] {
            let flattenedObject = object.mapValues(decompose)
            
            if let key = key(for: object) {
                save(flattenedObject, for: key)
                return key
            } else {
                return flattenedObject
            }
        } else if let objects = object as? [Any] {
            return objects.map(decompose)
        }
        
        return object // Primitive
    }
    
    func recompose(_ object: Any) throws -> Any {
        if let object = object as? [String: Any] {
            return try object.reduce(into: [String: Any]()) { result, item in
                result[item.key] = try recompose(item.value)
            }
        } else if let objects = object as? [Any] {
            return try objects.map(recompose)
        } else if let objectRef = object as? ObjectKey {
            if let thinObject = store[objectRef] {
                return try recompose(thinObject)
            } else {
                throw Failure.recomposition
            }
        }
        
        return object
    }
}

// helper API

extension Composer {
    func key(for object: [String: Any]) -> ObjectKey? {
        let value = object["id"]
        
        if let uuidString = value as? String, let id = UUID(uuidString: uuidString) {
            return .init(id: id)
        } else if let id = value as? UUID {
            return .init(id: id)
        } else {
            return nil
        }
    }
    
    func save(_ object: [String: Any], for key: ObjectKey) {
        if let current = store[key] {
            current.update(with: object)
        } else {
            store[key] = .init(json: object)
        }
    }
}
