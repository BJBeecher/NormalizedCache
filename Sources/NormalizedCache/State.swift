//
//  File.swift
//  
//
//  Created by BJ Beecher on 6/2/21.
//

import Foundation

struct State<Key: Hashable> {
    var decomposedEntries = [Key : Any]()
    var objects = [String : [String : Any]]()
}
