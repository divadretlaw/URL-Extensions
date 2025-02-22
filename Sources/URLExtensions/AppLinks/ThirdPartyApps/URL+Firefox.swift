//
//  URL+Firefox.swift
//  URL+Extensions
//
//  Created by David Walter on 10.07.23.
//

import Foundation

extension URL.ThirdParty {
    /// Creates a Firefox URL instance from the provided data.
    ///
    /// - Parameter url: The url to open
    public static func firefox(url: URL) -> URL {
        // swiftlint:disable:next force_unwrapping
        return URL(string: "firefox://open-url?url=\(url.string(omitScheme: true, addingPercentEncoding: .urlQueryAllowed))")!
    }
    
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
