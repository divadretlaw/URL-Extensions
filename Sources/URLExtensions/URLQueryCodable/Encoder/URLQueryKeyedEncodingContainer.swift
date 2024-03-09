//
//  URLQueryKeyedEncodingContainer.swift
//  URL+Extensions
//
//  Created by David Walter on 07.07.23.
//

import Foundation

final class URLQueryKeyedEncodingContainer<Key>: KeyedEncodingContainerProtocol where Key: CodingKey {
    let encoder: _URLQueryEncoder
    
    init(referencing encoder: _URLQueryEncoder) {
        self.encoder = encoder
    }
    
    // MARK: - KeyedEncodingContainerProtocol
    
    var codingPath: [CodingKey] {
        encoder.codingPath
    }
    
    func encodeNil(forKey key: Key) throws {
    }
    
    func encode(_ value: Bool, forKey key: Key) throws {
        encoder.storage[key.stringValue] = value.description
    }
    
    func encode(_ value: String, forKey key: Key) throws {
        encoder.storage[key.stringValue] = value.description
    }
    
    func encode(_ value: Double, forKey key: Key) throws {
        encoder.storage[key.stringValue] = value.description
    }
    
    func encode(_ value: Float, forKey key: Key) throws {
        encoder.storage[key.stringValue] = value.description
    }
    
    func encode(_ value: Int, forKey key: Key) throws {
        encoder.storage[key.stringValue] = value.description
    }
    
    func encode(_ value: Int8, forKey key: Key) throws {
        encoder.storage[key.stringValue] = value.description
    }
    
    func encode(_ value: Int16, forKey key: Key) throws {
        encoder.storage[key.stringValue] = value.description
    }
    
    func encode(_ value: Int32, forKey key: Key) throws {
        encoder.storage[key.stringValue] = value.description
    }
    
    func encode(_ value: Int64, forKey key: Key) throws {
        encoder.storage[key.stringValue] = value.description
    }
    
    func encode(_ value: UInt, forKey key: Key) throws {
        encoder.storage[key.stringValue] = value.description
    }
    
    func encode(_ value: UInt8, forKey key: Key) throws {
        encoder.storage[key.stringValue] = value.description
    }
    
    func encode(_ value: UInt16, forKey key: Key) throws {
        encoder.storage[key.stringValue] = value.description
    }
    
    func encode(_ value: UInt32, forKey key: Key) throws {
        encoder.storage[key.stringValue] = value.description
    }
    
    func encode(_ value: UInt64, forKey key: Key) throws {
        encoder.storage[key.stringValue] = value.description
    }
    
    func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
        let encoder = _URLQueryEncoder(at: encoder.codingPath + [key], with: encoder.options)
        try value.encode(to: encoder)
        
        if !encoder.storage.isEmpty {
            let encodedValue = encoder.storage.pop()
            self.encoder.storage[key.stringValue] = encodedValue.description.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? encodedValue.description
        } else {
            switch encoder.options.nestedValueStrategy {
            case .error:
                throw URLQueryEncoder.Error.unsupported("Nested containers are not supported.")
            case .flatten:
                for (key, value) in encoder.storage {
                    self.encoder.storage[key] = value
                }
            }
        }
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        fatalError("URLQueryEncoder does not support nested keyed containers.")
    }
    
    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        fatalError("URLQueryEncoder does not support nested unkeyed containers.")
    }
    
    func superEncoder() -> Encoder {
        self.encoder.storage["super"] = nil
        return _URLQueryEncoder(at: encoder.codingPath + [URLQueryCodingKey.superKey], with: encoder.options)
    }
    
    func superEncoder(forKey key: Key) -> Encoder {
        self.encoder.storage[key.stringValue] = nil
        return _URLQueryEncoder(at: encoder.codingPath + [key], with: encoder.options)
    }
}
