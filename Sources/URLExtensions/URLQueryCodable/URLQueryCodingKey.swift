//
//  URLQueryCodingKey.swift
//  URL+Extensions
//
//  Created by David Walter on 07.07.23.
//

import Foundation

struct URLQueryCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init?(intValue: Int) {
        self.stringValue = intValue.description
        self.intValue = intValue
    }
    
    // swiftlint:disable:next force_unwrapping
    static let superKey = URLQueryCodingKey(stringValue: "super")!
}
