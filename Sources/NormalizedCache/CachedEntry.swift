//
//  File.swift
//  
//
//  Created by BJ Beecher on 6/9/21.
//

import Foundation
import Combine

public final class CachedEntry {
    @Published var value : DecomposedValue
    
    let composer : Composer
    
    init(value: DecomposedValue, composer: Composer = .shared){
        self.value = value
        self.composer = composer
    }
}

// API

public extension CachedEntry {
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
        value.json = try composer.tearDown(object: object)
    }
}
