//
//  ComposerTests.swift
//  UpdateCacheTests
//
//  Created by BJ Beecher on 5/17/21.
//

import XCTest
@testable import NormalizedCache

class MockComposerStore : ObjectStoreInterface {
    
    var objects = [String : ObjectValue]()
    
    subscript(key: String) -> ObjectValue? {
        get {
            objects[key]
        }
        set(newValue) {
            objects[key] = newValue
        }
    }
}

class ComposerTests: XCTestCase {
    
    let store = MockComposerStore()
    lazy var composer = Composer(store: store)
    
    func object(id: String) -> [String : JSONObject]  {
        ["id": id, "name": "Phillip"]
    }
    
    func testKeyMethod(){
        // given
        let id = UUID().uuidString
        
        // when
        let key = composer.key(for: object(id: id))
        
        // then
        assert(key == "~>\(id)")
    }
    
    func testSaveMethod() throws {
        // given
        let id = UUID().uuidString
        let json = object(id: id)
        let value = try ObjectValue(object: json)
        let key = "~>\(id)"
        
        // when
        try composer.save(json, for: key)
        
        // then
        XCTAssertEqual(store.objects[key], value)
    }
    
    func testDecomposeObject() throws {
        // given
        let id = UUID().uuidString
        let object = object(id: id)
        let key = composer.key(for: object)
        
        // when
        let decomposed = try composer.decompose(object)
        
        // then
        XCTAssertEqual(decomposed as? String, key)
    }
    
    func testDecomposeObjectNoKey() throws {
        // given
        let value = ["name":"Joe", "car":"Prius"] as JSONObject
        
        // when
        let decomposed = try composer.decompose(value)
        
        // then
        XCTAssertEqual(decomposed as? [String : String], value as? [String : String])
    }
    
    func testDecomposeArray() throws {
        // given
        let value = ["Tommy", "Matt", "Katie"] as [JSONObject]
        
        // when
        let decomposed = try composer.decompose(value)
        
        // then
        XCTAssertEqual(decomposed as? [String], value as? [String])
    }
    
    func testDecomposeArrayWithObject() throws {
        // given
        let id = UUID().uuidString
        let object = ["id":id, "name":"Brian"] as [String : JSONObject]
        let array = [object] as JSONObject
        let key = composer.key(for: object)!
        
        // when
        let decomposed = try composer.decompose(array)
        
        // then
        XCTAssertEqual(decomposed as? [String], [key])
    }
}
