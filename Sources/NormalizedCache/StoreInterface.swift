//
//  File.swift
//  
//
//  Created by BJ Beecher on 5/16/21.
//

import Cache
import Foundation

public protocol StoreInterface : AnyObject, Codable {
    associatedtype Key : Hashable, Codable
    subscript(key: Key) -> Data? { get set }
}

// conformance

extension Cache : StoreInterface where Key : Codable, Value == Data {}
