//
//  URLQueryKeyedDecodingContainer.swift
//  URL+Extensions
//
//  Created by David Walter on 07.07.23.
//

import Foundation

final class URLQueryKeyedDecodingContainer<Key>: KeyedDecodingContainerProtocol where Key: CodingKey {
    private var decoder: _URLQueryDecoder
    private var container: URLQueryStorage
    
    init(referencing decoder: _URLQueryDecoder, wrapping container: URLQueryStorage) {
        self.decoder = decoder
        self.container = container
    }
    
    // MARK: - Errors
    
    private func notFoundError(key: Key) -> DecodingError {
        DecodingError.keyNotFound(key, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "No value associated with key \(key.stringValue)."))
    }
    
    private func typeMismatchError<T>(key: Key, type: T) -> DecodingError {
        DecodingError.typeMismatch(T.self, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Type of value at key \(key.stringValue) was not expected."))
    }
    
    // MARK: - KeyedDecodingContainerProtocol
    
    var codingPath: [CodingKey] {
        decoder.codingPath
    }
    
    var allKeys: [Key] {
        container.keys.compactMap { Key(stringValue: $0) }
    }
    
    func contains(_ key: Key) -> Bool {
        container[key.stringValue] != nil
    }
    
    func decodeNil(forKey key: Key) throws -> Bool {
        guard let entry = self.container[key.stringValue] else {
            throw notFoundError(key: key)
        }
        
        return entry == "NULL"
    }
    
    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        guard let value = decoder.storage[key.stringValue] else {
            throw notFoundError(key: key)
        }

        return (value as NSString).boolValue
    }
    
    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        guard let value = decoder.storage[key.stringValue] else {
            throw notFoundError(key: key)
        }
        return value
    }
    
    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        guard let value = decoder.storage[key.stringValue] else {
            throw notFoundError(key: key)
        }
        guard let converted = Double(value) else {
            throw typeMismatchError(key: key, type: type)
        }
        return converted
    }
    
    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        guard let value = decoder.storage[key.stringValue] else {
            throw notFoundError(key: key)
        }
        guard let converted = Float(value) else {
            throw typeMismatchError(key: key, type: type)
        }
        return converted
    }
    
    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        guard let value = decoder.storage[key.stringValue] else {
            throw notFoundError(key: key)
        }
        guard let converted = Int(value) else {
            throw typeMismatchError(key: key, type: type)
        }
        return converted
    }
    
    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        guard let value = decoder.storage[key.stringValue] else {
            throw notFoundError(key: key)
        }
        guard let converted = Int8(value) else {
            throw typeMismatchError(key: key, type: type)
        }
        return converted
    }
    
    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        guard let value = decoder.storage[key.stringValue] else {
            throw notFoundError(key: key)
        }
        guard let converted = Int16(value) else {
            throw typeMismatchError(key: key, type: type)
        }
        return converted
    }
    
    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        guard let value = decoder.storage[key.stringValue] else {
            throw notFoundError(key: key)
        }
        guard let converted = Int32(value) else {
            throw typeMismatchError(key: key, type: type)
        }
        return converted
    }
    
    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        guard let value = decoder.storage[key.stringValue] else {
            throw notFoundError(key: key)
        }
        guard let converted = Int64(value) else {
            throw typeMismatchError(key: key, type: type)
        }
        return converted
    }
    
    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        guard let value = decoder.storage[key.stringValue] else {
            throw notFoundError(key: key)
        }
        guard let converted = UInt(value) else {
            throw typeMismatchError(key: key, type: type)
        }
        return converted
    }
    
    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        guard let value = decoder.storage[key.stringValue] else {
            throw notFoundError(key: key)
        }
        guard let converted = UInt8(value) else {
            throw typeMismatchError(key: key, type: type)
        }
        return converted
    }
    
    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        guard let value = decoder.storage[key.stringValue] else {
            throw notFoundError(key: key)
        }
        guard let converted = UInt16(value) else {
            throw typeMismatchError(key: key, type: type)
        }
        return converted
    }
    
    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        guard let value = decoder.storage[key.stringValue] else {
            throw notFoundError(key: key)
        }
        guard let converted = UInt32(value) else {
            throw typeMismatchError(key: key, type: type)
        }
        return converted
    }
    
    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        guard let value = decoder.storage[key.stringValue] else {
            throw notFoundError(key: key)
        }
        guard let converted = UInt64(value) else {
            throw typeMismatchError(key: key, type: type)
        }
        return converted
    }
    
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable {
        guard let value = decoder.storage[key.stringValue] else {
            throw notFoundError(key: key)
        }
        decoder.storage.push(value)
        return try type.init(from: decoder)
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
        throw URLQueryDecoder.Error.unsupported("URLQueryDecoder does not support nested keyed containers.")
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        throw URLQueryDecoder.Error.unsupported("URLQueryDecoder does not support nested unkeyed containers.")
    }
    
    func superDecoder() throws -> Decoder {
        self.container["super"] = nil
        return _URLQueryDecoder(referencing: self.container, at: decoder.codingPath + [URLQueryCodingKey.superKey])
    }
    
    func superDecoder(forKey key: Key) throws -> Decoder {
        self.container[key.stringValue] = nil
        return _URLQueryDecoder(referencing: self.container, at: decoder.codingPath + [key])
    }
}
