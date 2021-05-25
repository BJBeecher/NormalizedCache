//
//  File.swift
//  
//
//  Created by BJ Beecher on 5/25/21.
//

import Foundation

public protocol JSONObject {}

// conformance

extension String : JSONObject {}
extension Double : JSONObject {}
extension Float : JSONObject {}
extension Int : JSONObject {}
extension Array : JSONObject where Element == JSONObject {}
extension Dictionary : JSONObject where Key == String, Value == JSONObject {}
