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
        
        lazy var cache = NormalizedCache(store: store, composer: composer)
        
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
    }
