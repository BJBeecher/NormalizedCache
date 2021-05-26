//
//  File.swift
//  
//
//  Created by BJ Beecher on 5/25/21.
//

import Foundation

protocol Serializer {
    func json(from data: Data) throws -> JSONObject
    func data(from json: Any) throws -> Data
}

// conformance

final class DefaultSerializer : Serializer {
    typealias JSONFetch = (Data, JSONSerialization.ReadingOptions) throws -> Any
    typealias DataFetch = (Any, JSONSerialization.WritingOptions) throws -> Data
    
    let jsonObject : JSONFetch
    let fetchData : DataFetch
    
    init(jsonObject: @escaping JSONFetch, fetchData: @escaping DataFetch) {
        self.jsonObject = jsonObject
        self.fetchData = fetchData
    }
    
    convenience init() {
        self.init(jsonObject: JSONSerialization.jsonObject, fetchData: JSONSerialization.data)
    }
    
    func json(from data: Data) throws -> JSONObject {
        if let json = try jsonObject(data, [.fragmentsAllowed]) as? JSONObject {
            return json
        } else {
            throw Failure.serializer
        }
    }
    
    func data(from json: Any) throws -> Data {
        try fetchData(json, [.fragmentsAllowed])
    }
}
