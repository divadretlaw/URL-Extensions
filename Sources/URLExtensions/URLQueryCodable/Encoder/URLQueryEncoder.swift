//
//  URLQueryEncoder.swift
//  URL+Extensions
//
//  Created by David Walter on 07.07.23.
//

import Foundation

/// An object that encodes instances of a data type as URL query objects.
public final class URLQueryEncoder {
    /// The strategy to resolve nested values with.
    public var nestedValueStrategy: NestedValueStrategy = .error

    /// Strategy to resolve nested values.
    public enum NestedValueStrategy {
        /// Throw an error if there are neseted values.
        case error
        /// Try to flatten the nested values.
        case flatten
    }
    
    /// A dictionary you use to customize the encoding process by providing contextual information.
    public var userInfo: [CodingUserInfoKey: Any] = [:]
    
    private var options: Options {
        Options(nestedValueStrategy: nestedValueStrategy,
                userInfo: userInfo)
    }

    struct Options {
        let nestedValueStrategy: NestedValueStrategy
        let userInfo: [CodingUserInfoKey: Any]
    }
    
    /// Creates a new, reusable URL query encoder with the default formatting settings and encoding strategies.
    public init() {
    }
    
    /// Returns a URL-query-encoded `String` representation of the value you supply.
    public func encode<T: Encodable>(_ value: T) throws -> String {
        let encoder = _URLQueryEncoder(with: options)
        try value.encode(to: encoder)
        return encoder.storage.map { key, value in
            "\(key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value)"
        }
        .joined(separator: "&")
    }
    
    /// Returns an array of `URLQueryItem` items representation of the value you supply.
    public func encode<T: Encodable>(_ value: T) throws -> [URLQueryItem] {
        let encoder = _URLQueryEncoder(with: options)
        try value.encode(to: encoder)
        return encoder.storage.map { key, value in
            URLQueryItem(name: key, value: value)
        }
    }
}

extension URLQueryEncoder {
    enum Error: Swift.Error {
        case unsupported(_ message: String)
    }
}

// swiftlint:disable:next type_name
final class _URLQueryEncoder: Encoder {
    var codingPath: [CodingKey]
    var storage: URLQueryStorage
    var options: URLQueryEncoder.Options
    
    init(at codingPath: [CodingKey] = [], with options: URLQueryEncoder.Options) {
        self.codingPath = codingPath
        self.storage = URLQueryStorage(container: [:])
        self.options = options
    }
    
    var userInfo: [CodingUserInfoKey: Any] {
        options.userInfo
    }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
        let container = URLQueryKeyedEncodingContainer<Key>(referencing: self)
        return KeyedEncodingContainer(container)
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError("URLQueryEncoder does not support unkeyed containers.")
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        URLQuerySingleValueEncodingContainer(referencing: self)
    }
}
