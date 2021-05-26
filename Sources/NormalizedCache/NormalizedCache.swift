//
//  File.swift
//  
//
//  Created by BJ Beecher on 5/3/21.
//

import Foundation
import Cache

public final class NormalizedCache<Key: Hashable> {
    
    let store : Cache<Key, Data>
    let composer : ComposerInterface
    let serializer : Serializer
    
    init(store: Cache<Key, Data>, composer: ComposerInterface, serializer: Serializer) {
        self.store = store
        self.composer = composer
        self.serializer = serializer
    }
    
    public convenience init() {
        self.init(store: .init(), composer: Composer(), serializer: DefaultSerializer())
    }
}

// json API

public extension NormalizedCache {
    func insert(_ json: JSONObject, for key: Key) throws {
        let decomposedValue = try composer.decompose(json)
        let data = try serializer.data(from: decomposedValue)
        store[key] = data
    }
    
    func json(for key: Key) throws -> JSONObject? {
        guard let data = store[key] else { return nil }
        let json = try serializer.json(from: data)
        let value = try composer.recompose(json)
        return value
    }
    
    func update(with json: JSONObject) throws {
        try composer.decompose(json)
    }
}

// data API

public extension NormalizedCache {
    func insert(_ data: Data, for key: Key) throws {
        let json = try serializer.json(from: data)
        try insert(json, for: key)
    }
    
    func data(for key: Key) throws -> Data? {
        guard let json = try json(for: key) else { return nil }
        let data = try serializer.data(from: json)
        return data
    }
    
    func update(with data: Data) throws {
        let json = try serializer.json(from: data)
        try update(with: json)
    }
}

// codable API

public extension NormalizedCache {
    func insert<Object: Codable>(_ object: Object, forKey key: Key) throws {
        let data = try JSONEncoder().encode(object)
        try insert(data, for: key)
    }
    
    func object<Object: Codable>(forKey key: Key) throws -> Object? {
        guard let data = try data(for: key) else { return nil }
        let object = try JSONDecoder().decode(Object.self, from: data)
        return object
    }
}
