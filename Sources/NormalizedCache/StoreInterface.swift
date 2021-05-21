//
//  File.swift
//  
//
//  Created by BJ Beecher on 5/16/21.
//

import Cache

public protocol StoreInterface : AnyObject {
    associatedtype Key : Hashable
    subscript(key: Key) -> Any? { get set }
}

// conformance

extension Cache : StoreInterface where Value == Any {}
