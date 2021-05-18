//
//  File.swift
//  
//
//  Created by BJ Beecher on 5/3/21.
//

import Foundation
import CacheKit

public final class UpdateCache {
    
    let store : StoreInterface
    
    let composer : ComposerInterface
    
    let encoder : JSONEncoder
    let decoder : JSONDecoder
    
    init(
        store: StoreInterface,
        composer: ComposerInterface,
        encoder: JSONEncoder,
        decoder: JSONDecoder
    ) {
        self.store = store
        self.composer = composer
        self.encoder = encoder
        self.decoder = decoder
    }
    
    public convenience init() {
        self.init(store: Cache<Int, Any>(), composer: Composer(), encoder: .init(), decoder: .init())
    }
}

// public API

public extension UpdateCache {
    func insert<Key: Hashable, Value: Codable>(_ value: Value, for key: Key) {
        let hash = key.hashValue
        
        if let data = try? data(from: value), let json = try? json(from: data) {
            let decomposed = composer.decompose(json)
            store[hash] = decomposed
        } else {
            store[hash] = value
        }
    }
    
    func value<Key: Hashable, Value: Codable>(for key: Key) -> Value? {
        let hash = key.hashValue
        
        guard let stored = store[hash] else { return nil }
        
        if let recomposed = try? composer.recompose(stored), let data = try? data(from: recomposed), let value : Value = try? object(from: data) {
            return value
        } else {
            return stored as? Value
        }
    }
}

// internal API

extension UpdateCache {
    func data<Object: Encodable>(from object: Object) throws -> Data {
        try encoder.encode(object)
    }
    
    func data(from json: Any) throws -> Data {
        try JSONSerialization.data(withJSONObject: json, options: [])
    }
    
    func json(from data: Data) throws -> Any {
        try JSONSerialization.jsonObject(with: data, options: [])
    }
    
    func object<Object: Decodable>(from data: Data) throws -> Object {
        try decoder.decode(Object.self, from: data)
    }
}
