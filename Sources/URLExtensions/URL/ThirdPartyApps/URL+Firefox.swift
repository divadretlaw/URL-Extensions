//
//  URL+Firefox.swift
//  URL+Extensions
//
//  Created by David Walter on 10.07.23.
//

import Foundation

extension URL {
    // MARK: - App
    
    public struct Firefox: Equatable, Hashable, Codable, AppLink {
        public let url: URL
        
        public init?(url: URL) {
            guard url.scheme(isAny: Self.schemes) else { return nil }
            self.url = url
        }
        
        // MARK: App Link
        
        public static var isDefaultApp: Bool { false }
        
        public static var schemes: [String] {
            ["firefox"]
        }
    }
}
