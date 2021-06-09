//
//  File.swift
//  
//
//  Created by BJ Beecher on 6/2/21.
//

import Foundation

struct State<EntryKey: Hashable> {
    var entries = [EntryKey : CachedValue<Any>]()
    var objects = [ObjectKey : CachedValue<[String : Any]>]()
}
