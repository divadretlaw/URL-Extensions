//
//  URL+DuckDuckGo.swift
//  URL+Extensions
//
//  Created by David Walter on 01.09.23.
//

import Foundation

extension URL.ThirdParty {
    /// Creates a DuckDuckGo URL instance from the provided data.
    ///
    /// - Parameter url: The url to open
    public static func duckDuckGo(url: URL) -> URL {
        // swiftlint:disable:next force_unwrapping
        return URL(string: "ddgQuickLink://\(url.string(omitScheme: true, addingPercentEncoding: .urlPathAllowed))")!
    }
    
    // MARK: - App
    
    public struct DuckDuckGoPrivacyBrowser: Equatable, Hashable, Codable, AppLink {
        public let url: URL
        
        public init?(url: URL) {
            guard url.scheme(isAny: Self.schemes) else { return nil }
            self.url = url
        }
        
        // MARK: App Link
        
        public static var isDefaultApp: Bool { false }
        
        public static var schemes: [String] {
            ["ddgLaunch", "ddgQuickLink"]
        }
    }
}
