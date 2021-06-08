//
//  File.swift
//  
//
//  Created by BJ Beecher on 6/8/21.
//

import Foundation

final class Entry {
    @Published var value : Any
    
    init(value: Any){
        self.value = value
    }
}
