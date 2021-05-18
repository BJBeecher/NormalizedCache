//
//  File.swift
//  
//
//  Created by BJ Beecher on 5/16/21.
//

import CacheKit

public protocol StoreInterface : AnyObject {
    subscript(key: Int) -> Any? { get set }
}

// conformance

extension Cache : StoreInterface where Key == Int, Value == Any {}
