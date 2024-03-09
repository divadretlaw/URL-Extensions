//
//  URL+Health.swift
//  URL+Extensions
//
//  Created by David Walter on 10.07.23.
//

import Foundation

extension URL {
    public static func health(tab: Health.Tab?) -> URL {
        // swiftlint:disable:next force_unwrapping
        return URL(string: "x-apple-health://\(tab?.rawValue ?? "")")!
    }
}

extension URL {
    // MARK: - App
    
    /// Health URL
    public struct Health: Equatable, Hashable, Codable, AppLink {
        public let url: URL
        public let tab: Tab?
        
        public init?(url: URL) {
            guard url.scheme(isAny: Self.schemes) else { return nil }
            self.url = url
            if let host = url.internalHost()?.lowercased() {
                self.tab = Tab(rawValue: host)
            } else {
                self.tab = nil
            }
        }
        
        public init(tab: Tab?) {
            self.url = URL.health(tab: tab)
            self.tab = tab
        }
        
        // MARK: App Link
        
        public static var isDefaultApp: Bool { true }
        
        public static var schemes: [String] {
            ["x-apple-health", "x-argonaut-app"]
        }
    }
}

// MARK: - Subtypes

extension URL.Health {
    public enum Tab: String, Codable, Sendable {
        case summary
        case browse
    }
}
