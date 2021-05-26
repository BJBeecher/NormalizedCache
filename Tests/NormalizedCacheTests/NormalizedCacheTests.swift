    import XCTest
    @testable import NormalizedCache
    import Cache
    
    final class MockComposer : ComposerInterface {
        func decompose(_ object: JSONObject) -> JSONObject {
            return object
        }
        
        func recompose(_ object: JSONObject) throws -> JSONObject {
            return object
        }
    }
    
    struct MockObject : Codable, Equatable {
        var id = UUID()
        let name : String
        var createdDt = Date()
    }

    final class UpdateCacheTests: XCTestCase {
        
        let store = Cache<UUID, Data>()
        let composer = MockComposer()
        
        lazy var cache = NormalizedCache(store: store, composer: composer, serializer: DefaultSerializer())
        
        func testDictionaryInsert() throws {
            // given
            let key = UUID()
            let value = ["id": UUID().uuidString, "name": "Tommy", "age": 34] as JSONObject
            
            // when
            try cache.insert(value, for: key)
            let data = try JSONSerialization.data(withJSONObject: value, options: [])
            
            // then
            XCTAssertEqual(store[key], data, "object inserted")
        }
        
        func testPrimitiveArrayInsert() throws {
            // given
            let key = UUID()
            let value = [5, 6, 7, 8] as [JSONObject]
            
            // when
            try cache.insert(value, for: key)
            let data = try JSONSerialization.data(withJSONObject: value, options: [])
            
            // then
            XCTAssertEqual(store[key], data, "primitive array inserted")
        }
        
        func testObjectArrayInsert() throws {
            // given
            let key = UUID()
            let value = [["id": UUID().uuidString, "name": "Tommy", "age": 34]] as [JSONObject]
            
            // when
            try cache.insert(value, for: key)
            let data = try JSONSerialization.data(withJSONObject: value, options: [])
            
            // then
            XCTAssertEqual(store[key], data, "object array inserted")
        }
        
        func testObjectInsert() throws {
            // given
            let cache = NormalizedCache<UUID>()
            let object = MockObject(name: "Tommy")
            let key = UUID()
            
            // when
            try cache.insert(object, forKey: key)
            let returnedObject : MockObject? = try cache.object(forKey: key)
            
            // then
            XCTAssertEqual(object, returnedObject)
        }
        
        func testArrayOfObjectsInsert() throws {
            // given
            let cache = NormalizedCache<UUID>()
            let object = [MockObject(name: "Tommy"), .init(name: "Matt")]
            let key = UUID()
            
            // when
            try cache.insert(object, forKey: key)
            let returnedObject : [MockObject]? = try cache.object(forKey: key)
            
            // then
            XCTAssertEqual(object, returnedObject)
        }
        
        func testArrayOfPrimitivesInsert() throws {
            // given
            let cache = NormalizedCache<UUID>()
            let object = [8, 7, 9] as [JSONObject]
            let key = UUID()
            
            // when
            try cache.insert(object, for: key)
            let returnedObject = try cache.json(for: key) as? [Int]
            
            // then
            XCTAssertEqual(object as? [Int], returnedObject)
        }
        
        func testPrimitiveInsert() throws {
            // given
            let cache = NormalizedCache<UUID>()
            let object = UUID()
            let key = UUID()
            
            // when
            try cache.insert(object, forKey: key)
            let returnedObject : UUID? = try cache.object(forKey: key)
            
            // then
            XCTAssertEqual(object, returnedObject)
        }
    }
