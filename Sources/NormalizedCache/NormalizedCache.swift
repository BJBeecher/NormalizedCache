//
//  File.swift
//  
//
//  Created by BJ Beecher on 5/3/21.
//

import Foundation
import Cache

public final class NormalizedCache<Store: StoreInterface> {
    
    let store : Store
    
    let composer : ComposerInterface
    
    init(
        store: Store,
        composer: ComposerInterface
    ) {
        self.store = store
        self.composer = composer
    }
}

// public API

public extension NormalizedCache {
    func insert(_ value: Any, for key: Store.Key) {
        let decomposedValue = composer.decompose(value)
        store[key] = decomposedValue
    }
    
    func value(for key: Store.Key) -> Any? {
        if let decomposedValue = store[key], let value = try? composer.recompose(decomposedValue) {
            return value
        } else {
            return nil
        }
    }
    
    subscript(key: Store.Key) -> Any? {
        get {
            value(for: key)
        } set {
            if let newValue = newValue {
                insert(newValue, for: key)
            }
        }
    }
}
