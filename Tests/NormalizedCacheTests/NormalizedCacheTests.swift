    import XCTest
    @testable import NormalizedCache
    
    final class MockEntryStore<Key: Hashable> : StoreInterface {
        
        var entries = [Key : Any]()
        
        subscript(key: Key) -> Any? {
            get {
                entries[key]
            }
            set(newValue) {
                entries[key] = newValue
            }
        }
    }
    
    final class MockComposer : ComposerInterface {
        func decompose(_ object: Any) -> Any {
            return object
        }
        
        func recompose(_ object: Any) throws -> Any {
            return object
        }
    }
    
    struct MockObject : Codable, Equatable {
        var id = UUID()
        let name : String
        var createdDt = Date()
    }

    final class UpdateCacheTests: XCTestCase {
        
        let store = MockEntryStore<UUID>()
        let composer = MockComposer()
        
        lazy var cache = NormalizedCache(store: store, composer: composer)
        
        func testPrimitiveInsert() {
            // given
            let key = UUID()
            let value = UUID()
            
            // when
            cache.insert(value, for: key)
            
            // then
            XCTAssertEqual(store.entries[key] as? UUID, value, "primitive entered")
        }
        
        func testObjectInsert(){
            // given
            let key = UUID()
            let value = MockObject(name: "Tommy")
            
            // when
            cache.insert(value, for: key)
            let entry = store.entries[key] as? MockObject
            
            // then
            XCTAssertEqual(entry?.name, value.name)
            XCTAssertEqual(entry?.id, value.id)
        }
        
        func testPrimitiveArrayInsert(){
            // given
            let key = UUID()
            let value = [5, 6, 7, 8]
            
            // when
            cache.insert(value, for: key)
            
            // then
            XCTAssertEqual(store.entries[key] as? [Int], value, "array inserted")
        }
        
        func testObjectArrayInsert(){
            // given
            let key = UUID()
            let value = [MockObject(name: "Tommy")]
            
            // when
            cache[key] = value
            
            // then
            XCTAssertEqual(cache[key] as? [MockObject], value)
        }
    }
