//
//  File.swift
//  
//
//  Created by BJ Beecher on 6/9/21.
//

import Foundation

final class Composer {
    var objects = [ObjectKey : CachedObject]()
    
    private init(){}
    
    static let shared = Composer()
}

// API

extension Composer {
    
    @discardableResult func tearDown<Object: Codable>(object: Object) throws -> DecomposedValue {
        let data = try JSONEncoder().encode(object)
        let json = try JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
        let decomposed = decompose(json)
        return .init(json: decomposed)
    }
    
    func build<Object: Codable>(from value: Any) throws -> Object {
        let json = try recompose(value)
        let data = try JSONSerialization.data(withJSONObject: json, options: [.fragmentsAllowed])
        let object = try JSONDecoder().decode(Object.self, from: data)
        return object
    }
    
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
                
            case let json as ObjectKey:
                if let object = objects[json]?.json {
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
    func key(for object: [String : Any]) -> ObjectKey? {
        if let uuidString = object["id"] as? String, let id = UUID(uuidString: uuidString) {
            return .init(id: id)
        } else {
            return nil
        }
    }
    
    /// Saves json object to cache state - merges if exists
    /// - Parameters:
    ///   - new: Value to be inserted
    ///   - key: Key for value
    func save(json value: [String : Any], for key: ObjectKey) {
        if let object = objects[key] {
            object.merge(with: value)
        } else {
            objects[key] = .init(json: value)
        }
    }
}
