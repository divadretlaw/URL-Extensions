import Foundation
import Testing
@testable import URLExtensions

struct URLQueryCodableTests {
    @Test func encodable() throws {
        let data = URL.AppleMapsParameter(mapType: .satellite, address: "Cupertino, California")
        let encoded: [URLQueryItem] = try URLQueryEncoder().encode(data)
        
        guard var components = URLComponents(string: "https://maps.apple.com") else { return }
        components.queryItems = encoded
        #expect(components.url != nil)
    }

    @Test func otherEncodable() throws {
        struct Test: Codable {
            var value: Value
            var date: Date
        }
        
        struct Value: Codable {
            var a: String
        }
        
        let data = Test(value: Value(a: "Value"), date: Date())
        let encoder = URLQueryEncoder()
        encoder.nestedValueStrategy = .flatten
        let encoded: String = try encoder.encode(data)
        print(encoded)
    }

    @Test func allTypesCodable() throws {
        struct Test: Codable, Equatable {
            var someBool: Bool = true
            var someString: String = "Test"
            var someDate: Date = Date()
            
            var someInt: Int = 1
            var someInt8: Int8 = -8
            var someInt16: Int16 = -16
            var someInt32: Int32 = -32
            var someInt64: Int64 = -64
            
            var someUInt: UInt = 1
            var someUInt8: UInt8 = 8
            var someUInt16: UInt16 = 16
            var someUInt32: UInt32 = 32
            var someUInt64: UInt64 = 64
            
            var someDouble: Double = 3.14
            var someFloat: Float = 3.14
        }
        
        let data = Test()
        
        let encoder = URLQueryEncoder()
        encoder.nestedValueStrategy = .flatten
        let encoded: String = try encoder.encode(data)
        print(encoded)
        
        let decoder = URLQueryDecoder()
        let decoded = try decoder.decode(Test.self, from: encoded)
        #expect(data == decoded)
    }

    @Test func decodable() throws {
        let url = try #require(URL(string: "https://maps.apple.com/?address=Cupertino&t=k&asdf=jklo"))

        guard let query = url.query else {
            Issue.record("Invalid query in URL.")
            return
        }
        
        let decoded = try URLQueryDecoder().decode(URL.AppleMapsParameter.self, from: Data(query.utf8))
        #expect(decoded.mapType == .satellite)
        #expect(decoded.address == "Cupertino")
    }

    @Test func encodeDecode() throws {
        let data = URL.AppleMapsParameter(mapType: .satellite, address: "Cupertino, California")
        let encoded: String = try URLQueryEncoder().encode(data)
        let decoded = try URLQueryDecoder().decode(URL.AppleMapsParameter.self, from: encoded)
        #expect(data == decoded)
    }
}
