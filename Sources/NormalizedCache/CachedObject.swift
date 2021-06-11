//
//  File.swift
//  
//
//  Created by BJ Beecher on 6/11/21.
//

import Foundation
import Combine

public final class CachedObject {
    @Published var json : [String : Any]
    
    let composer : Composer
    
    init(json: [String : Any], composer: Composer = .shared){
        self.json = json
        self.composer = composer
    }
}

// API

public extension CachedObject {
    func object<Object: Codable>() throws -> Object {
        try composer.build(from: json)
    }
    
    func objectPublisher<Object: Codable>() -> AnyPublisher<Object, Error> {
        $json
            .tryMap(composer.build)
            .eraseToAnyPublisher()
    }
    
    func update<Object: Codable>(with object: Object) throws {
        try composer.tearDown(object: object)
    }
}

// internal

extension CachedObject {
    func merge(with object: [String : Any]){
        json.merge(object) { old, new in new }
    }
}
