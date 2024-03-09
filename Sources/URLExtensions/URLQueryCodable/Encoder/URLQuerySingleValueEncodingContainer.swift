//
//  URLQuerySingleValueEncodingContainer.swift
//  URL+Extensions
//
//  Created by David Walter on 07.07.23.
//

import Foundation

final class URLQuerySingleValueEncodingContainer: SingleValueEncodingContainer {
    private var encoder: _URLQueryEncoder
    
    init(referencing encoder: _URLQueryEncoder) {
        self.encoder = encoder
    }
    
    // MARK: - SingleValueEncodingContainer
    
    var codingPath: [CodingKey] {
        encoder.codingPath
    }
    
    func encodeNil() throws {
    }
    
    func encode(_ value: Bool) throws {
        encoder.storage.push(value.description)
    }
    
    func encode(_ value: String) throws {
        encoder.storage.push(value.description)
    }
    
    func encode(_ value: Double) throws {
        encoder.storage.push(value.description)
    }
    
    func encode(_ value: Float) throws {
        encoder.storage.push(value.description)
    }
    
    func encode(_ value: Int) throws {
        encoder.storage.push(value.description)
    }
    
    func encode(_ value: Int8) throws {
        encoder.storage.push(value.description)
    }
    
    func encode(_ value: Int16) throws {
        encoder.storage.push(value.description)
    }
    
    func encode(_ value: Int32) throws {
        encoder.storage.push(value.description)
    }
    
    func encode(_ value: Int64) throws {
        encoder.storage.push(value.description)
    }
    
    func encode(_ value: UInt) throws {
        encoder.storage.push(value.description)
    }
    
    func encode(_ value: UInt8) throws {
        encoder.storage.push(value.description)
    }
    
    func encode(_ value: UInt16) throws {
        encoder.storage.push(value.description)
    }
    
    func encode(_ value: UInt32) throws {
        encoder.storage.push(value.description)
    }
    
    func encode(_ value: UInt64) throws {
        encoder.storage.push(value.description)
    }
    
    func encode<T>(_ value: T) throws where T: Encodable {
        try value.encode(to: encoder)
    }
}
