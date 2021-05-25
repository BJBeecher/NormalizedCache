//
//  File.swift
//  
//
//  Created by BJ Beecher on 5/16/21.
//

import Foundation

protocol ObjectStoreInterface {
    subscript(key: String) -> ObjectValue? { get set }
}

// conformance

extension Dictionary : ObjectStoreInterface where Key == String, Value == ObjectValue {}
