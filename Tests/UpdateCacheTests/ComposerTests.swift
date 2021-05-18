//
//  ComposerTests.swift
//  UpdateCacheTests
//
//  Created by BJ Beecher on 5/17/21.
//

import XCTest
@testable import UpdateCache

class MockComposerStore : ObjectStoreInterface {
    
    var objects = [ObjectKey : ObjectValue]()
    
    subscript(key: ObjectKey) -> ObjectValue? {
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
    
    func object(id: UUID) -> [String: Any]  {
        ["id": id, "name": "Phillip"]
    }
    
    func testKeyMethod(){
        let id = UUID()
        let key = composer.key(for: object(id: id))
        
        assert(id == key?.id)
    }
    
    func testSaveMethod(){
        let id = UUID()
        let key = ObjectKey(id: id)
        let json = object(id: id)
        
        composer.save(json, for: key)
        
        assert(store.objects[key]?.value.json["name"] as? String == json["name"] as? String)
    }
    
    func testDecomposeObject(){
        let id = UUID()
        let key = ObjectKey(id: id)
        let value = ["id": id, "name": "Joe"] as [String:Any]
        
        let decomposed = composer.decompose(value)
        
        assert(store.objects[key]?.value.json["name"] as? String == value["name"] as? String)
        assert(decomposed as? ObjectKey == key)
    }
    
    func testDecomposeObjectNoKey(){
        let value = ["name":"Joe", "car":"Prius"] as [String:Any]
        let decomposed = composer.decompose(value)
        
        assert((decomposed as? [String:Any])?["car"] as? String == value["car"] as? String)
    }
    
    func testDecomposeArray(){
        let value = ["Tommy", "Matt", "Katie"]
        let decomposed = composer.decompose(value)
        
        assert(value == decomposed as? [String])
    }
    
    func testDecomposeArrayWithObject(){
        let id = UUID()
        let key = ObjectKey(id: id)
        let object = ["id":id, "name":"Brian"] as [String:Any]
        let array = ["5", object, "6"] as [Any]
        let decomposed = composer.decompose(array)
        
        assert((decomposed as? [Any])?[1] as? ObjectKey == key)
        assert(store.objects[key]?.value.json["name"] as? String == object["name"] as? String)
    }
}
