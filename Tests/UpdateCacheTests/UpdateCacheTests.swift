    import XCTest
    @testable import UpdateCache
    
    final class MockEntryStore : StoreInterface {
        
        var entries = [Int : Any]()
        
        subscript(key: Int) -> Any? {
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
        
        let store = MockEntryStore()
        let composer = MockComposer()
        
        lazy var cache = UpdateCache(store: store, composer: composer, encoder: .init(), decoder: .init())
        
        func testPrimitiveInsert() {
            let key = UUID()
            let value = UUID()
            cache.insert(value, for: key)
            XCTAssertEqual(store.entries[key.hashValue] as? UUID, value, "primitive entered")
        }
        
        func testObjectInsert(){
            let key = UUID()
            let value = MockObject(name: "Tommy")
            cache.insert(value, for: key)
            
            let entry = store.entries[key.hashValue] as? [String:Any]
            
            XCTAssertEqual(entry?["name"] as? String, value.name, "object entered")
            XCTAssertEqual(entry?["id"] as? String, value.id.uuidString, "object entered")
        }
        
        func testArrayInsert(){
            let key = UUID()
            let value = [5, 6, 7, 8]
            
            cache.insert(value, for: key)
            
            let entry = store.entries[key.hashValue] as? [Int]
            
            XCTAssertEqual(entry?[0], value[0], "array inserted")
        }
    }
