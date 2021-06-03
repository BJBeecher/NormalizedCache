//
//  File.swift
//  
//
//  Created by BJ Beecher on 5/3/21.
//

import Foundation
import Cache

public final class NormalizedCache<Key: Hashable> {
    
    var state : State<Key>
    
    init(initialState state: State<Key>) {
        self.state = state
    }
    
    public convenience init() {
        self.init(initialState: .init())
    }
}

// codable API

public extension NormalizedCache {
    
    /// Inserts object into cache by transforming it from object -> data ->  composed native json (i.e. Any) -> decomposed json
    /// - Parameters:
    ///   - object: Codable object
    ///   - key: Hashable key
    /// - Throws: If error occurs in transformation process
    func insert<Object: Codable>(_ object: Object, forKey key: Key) throws {
        let data = try JSONEncoder().encode(object)
        let json = try JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
        let decomposed = decompose(json)
        state.decomposedEntries[key] = decomposed
    }
    
    /// Fetches object by transforming it from decomposed json -> composed json -> data -> object
    /// - Parameter key: Hashable key
    /// - Throws: during error in recomposition process
    /// - Returns: Codable object
    func object<Object: Codable>(forKey key: Key) throws -> Object? {
        guard let decomposedJSON = state.decomposedEntries[key] else { return nil }
        let recomposedJSON = try recompose(decomposedJSON)
        let data = try JSONSerialization.data(withJSONObject: recomposedJSON, options: [.fragmentsAllowed])
        let object = try JSONDecoder().decode(Object.self, from: data)
        return object
    }
    
    
    subscript<Object: Codable>(key: Key) -> Object? {
        get {
            do {
                return try object(forKey: key)
            } catch {
                print(error)
                return nil
            }
        }
        set {
            do {
                try insert(newValue, forKey: key)
            } catch {
                print(error)
            }
        }
    }
}

// composer

extension NormalizedCache {
    
    /// Decomposes native json by testing for certain attributes - Dictionary, Array, Primitive
    /// - Parameter json: Should only be native json objects
    /// - Returns: Decomposed json
    @discardableResult func decompose(_ json: Any) -> Any {
        switch json {
            case let json as [String : Any]:
                let flattenedObject = json.mapValues(decompose)
                guard let key = key(for: json) else { return flattenedObject }
                save(json: flattenedObject, for: key)
                return key
                
            case let json as [Any]:
                return json.map(decompose)
                
            default:
                return json
        }
    }
    
    /// Recompose JSON that was decomposed
    /// - Parameter json: Native Swift Objects
    /// - Throws: Recomposition error
    /// - Returns: recomposed json
    func recompose(_ json: Any) throws -> Any {
        switch json {
            case let json as [String : Any]:
                return try json.reduce(into: [:]) { result, item in
                    result[item.key] = try recompose(item.value)
                }
                
            case let json as [Any]:
                return try json.map(recompose)
                
            case let json as String:
                guard json.contains("~>") else { return json }
                if let object = state.objects[json] {
                    return try recompose(object)
                } else {
                    throw Failure.recomposition
                }
                
            default:
                return json
        }
    }
    
    /// Fetches object reference as string
    /// - Parameter object: JSON Dictionary
    /// - Returns: object reference
    func key(for object: [String : Any]) -> String? {
        if let id = object["id"] as? String, UUID(uuidString: id) != nil {
            return "~>\(id)"
        } else {
            return nil
        }
    }
    
    /// Saves json object to cache state - merges if exists
    /// - Parameters:
    ///   - new: Value to be inserted
    ///   - key: Key for value
    func save(json new: [String : Any], for key: String) {
        if let old = state.objects[key] {
            let merged = old.merging(new) { old, new in new }
            state.objects[key] = merged
        } else {
            state.objects[key] = new
        }
    }
}
