//
//  File.swift
//  
//
//  Created by BJ Beecher on 5/3/21.
//

import Foundation
import Combine

public final class NormalizedCache<Key: Hashable> {
    var entries = [Key : CachedValue<Any>]()
}

// codable API

public extension NormalizedCache {
    
    /// Inserts object into cache by transforming it from object -> data ->  composed native json (i.e. Any) -> decomposed json
    /// - Parameters:
    ///   - object: Codable object
    ///   - key: Hashable key
    /// - Throws: If error occurs in transformation process
    func insert<Object: Codable>(_ object: Object, forKey key: Key) throws -> CachedValue<Any> {
        let value = try CachedValue(object: object)
        entries[key] = value
        return value
    }
    
    /// Fetches object by transforming it from decomposed json -> composed json -> data -> object
    /// - Parameter key: Hashable key
    /// - Throws: during error in recomposition process
    /// - Returns: Codable object
    func value(forKey key: Key) -> CachedValue<Any>? {
        entries[key]
    }
}
