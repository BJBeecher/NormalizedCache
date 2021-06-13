//
//  File.swift
//  
//
//  Created by BJ Beecher on 6/12/21.
//

import Foundation
import Combine

public final class CachedValue<Value> {
    
    @Published var value : Value
    
    let composer : Composer
    
    init(value: Value, composer: Composer = .shared){
        self.value = value
        self.composer = composer
    }
}

// public API

public extension CachedValue where Value == DecomposedValue {
    func object<Object: Codable>() throws -> Object {
        try composer.build(from: value.json)
    }
    
    func objectPublisher<Object: Codable>() -> AnyPublisher<Object, Error> {
        $value
            .map(\.json)
            .tryMap(composer.build)
            .eraseToAnyPublisher()
    }
    
    func update<Object: Codable>(with object: Object) throws {
        value = try composer.tearDown(object: object)
    }
}

public extension CachedValue where Value == [String : Any] {
    func update<Object: Codable>(with object: Object) throws {
        try composer.tearDown(object: object)
    }
}

extension CachedValue where Value == [String : Any] {
    func merge(with object: [String : Any]){
        value.merge(object) { old, new in new }
    }
}
