//
//  URLQuerySingleValueDecodingContainer.swift
//  URL+Extensions
//
//  Created by David Walter on 07.07.23.
//

import Foundation

final class URLQuerySingleValueDecodingContainer: SingleValueDecodingContainer {
    private var decoder: _URLQueryDecoder
    
    init(referencing decoder: _URLQueryDecoder) {
        self.decoder = decoder
    }
    
    // MARK: - Errors
    
    private func typeMismatchError<T>( type: T) -> DecodingError {
        DecodingError.typeMismatch(T.self, DecodingError.Context(codingPath: self.decoder.codingPath, debugDescription: "Type of value was not expected."))
    }
    
    // MARK: - SingleValueDecodingContainer
    
    var codingPath: [CodingKey] {
        decoder.codingPath
    }
    
    func decodeNil() -> Bool {
        false
    }
    
    func decode(_ type: Bool.Type) throws -> Bool {
        (decoder.storage.pop() as NSString).boolValue
    }
    
    func decode(_ type: String.Type) throws -> String {
        decoder.storage.pop()
    }
    
    func decode(_ type: Double.Type) throws -> Double {
        guard let converted = Double(decoder.storage.pop()) else {
            throw typeMismatchError(type: type)
        }
        return converted
    }
    
    func decode(_ type: Float.Type) throws -> Float {
        guard let converted = Float(decoder.storage.pop()) else {
            throw typeMismatchError(type: type)
        }
        return converted
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        guard let converted = Int(decoder.storage.pop()) else {
            throw typeMismatchError(type: type)
        }
        return converted
    }
    
    func decode(_ type: Int8.Type) throws -> Int8 {
        guard let converted = Int8(decoder.storage.pop()) else {
            throw typeMismatchError(type: type)
        }
        return converted
    }
    
    func decode(_ type: Int16.Type) throws -> Int16 {
        guard let converted = Int16(decoder.storage.pop()) else {
            throw typeMismatchError(type: type)
        }
        return converted
    }
    
    func decode(_ type: Int32.Type) throws -> Int32 {
        guard let converted = Int32(decoder.storage.pop()) else {
            throw typeMismatchError(type: type)
        }
        return converted
    }
    
    func decode(_ type: Int64.Type) throws -> Int64 {
        guard let converted = Int64(decoder.storage.pop()) else {
            throw typeMismatchError(type: type)
        }
        return converted
    }
    
    func decode(_ type: UInt.Type) throws -> UInt {
        guard let converted = UInt(decoder.storage.pop()) else {
            throw typeMismatchError(type: type)
        }
        return converted
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        guard let converted = UInt8(decoder.storage.pop()) else {
            throw typeMismatchError(type: type)
        }
        return converted
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        guard let converted = UInt16(decoder.storage.pop()) else {
            throw typeMismatchError(type: type)
        }
        return converted
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        guard let converted = UInt32(decoder.storage.pop()) else {
            throw typeMismatchError(type: type)
        }
        return converted
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        guard let converted = UInt64(decoder.storage.pop()) else {
            throw typeMismatchError(type: type)
        }
        return converted
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        try type.init(from: decoder)
    }
}
