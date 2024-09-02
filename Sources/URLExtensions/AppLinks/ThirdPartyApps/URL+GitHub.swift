//
//  URL+GitHub.swift
//  URL+Extensions
//
//  Created by David Walter on 01.09.23.
//

import Foundation

extension URL {
    // MARK: - App
    
    public struct GitHub: Equatable, Hashable, Codable, AppLink {
        public let url: URL
        
        public init?(url: URL) {
            guard url.scheme(isAny: Self.schemes) else { return nil }
            self.url = url
        }
        
        // MARK: App Link
        
        public static var isDefaultApp: Bool { false }
        
        public static var schemes: [String] {
            ["github"]
        }
    }
}
