    import XCTest
    @testable import NormalizedCache
    
    struct MockObject : Codable, Equatable {
        var id = UUID()
        let name : String
        let subObject : MockSubObject
        var createdDt = Date()
    }
    
    struct MockSubObject : Codable, Equatable {
        var id = UUID()
        var body : String
        var createdDt = Date()
    }

    final class UpdateCacheTests: XCTestCase {
        func testObjectInsert() throws {
            // given
            let cache = NCClient<UUID>()
            let object = MockObject(name: "Tommy", subObject: .init(body: "IDK"))
            let key = UUID()
            
            // when
            let value = try cache.insert(object, forKey: key)
            let returnedObject : MockObject = try value.object()
            
            // then
            XCTAssertEqual(object, returnedObject)
        }
        
        func testArrayOfObjectsInsert() throws {
            // given
            let cache = NCClient<UUID>()
            let object = [MockObject(name: "Tommy", subObject: .init(body: "Cool")), .init(name: "Matt", subObject: .init(body: "Truck"))]
            let key = UUID()
            
            // when
            let value = try cache.insert(object, forKey: key)
            let returnedObject : [MockObject] = try value.object()
            
            // then
            XCTAssertEqual(object, returnedObject)
        }
        
        func testPrimitiveInsert() throws {
            // given
            let cache = NCClient<UUID>()
            let object = UUID()
            let key = UUID()
            
            // when
            let value = try cache.insert(object, forKey: key)
            let returnedObject : UUID = try value.object()
            
            // then
            XCTAssertEqual(object, returnedObject)
        }
    }
