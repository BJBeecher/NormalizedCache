//
//  File.swift
//  
//
//  Created by BJ Beecher on 6/9/21.
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

// convenience initializers

extension CachedValue where Value == Any {
    convenience init<Object: Codable>(object: Object, composer: Composer = .shared) throws {
        let decomposed = try composer.tearDown(object: object)
        self.init(value: decomposed, composer: composer)
    }
}

// API

extension CachedValue {
    func object<Object: Codable>() throws -> Object {
        try composer.build(from: value)
    }
    
    func objectPublisher<Object: Codable>() -> AnyPublisher<Object, Error> {
        $value
            .tryMap(composer.build)
            .eraseToAnyPublisher()
    }
}

// entry methods

// object methods

extension CachedValue where Value == [String : Any] {
    func update(with newValue: [String : Any]){
        let merged = value.merging(newValue) { old, new in new }
        value = merged
    }
}
