//
//  File.swift
//  
//
//  Created by BJ Beecher on 6/2/21.
//

import Foundation

struct State<EntryKey: Hashable> {
    var entries = [EntryKey : Entry]()
    var objects = [ObjectKey : Object]()
}
