//
//  URL+Reminders.swift
//  URL+Extensions
//
//  Created by David Walter on 12.07.23.
//

import Foundation

extension URL {
    public static func reminder(id: String? = nil) -> URL {
        let string = ["x-apple-reminder://", id]
            .compactMap { $0 }
            .joined()
        // swiftlint:disable:next force_unwrapping
        return URL(string: string)!
    }
}

extension URL {
    // MARK: - App
    
    public struct Reminders: Equatable, Hashable, Codable, AppLink {
        public let url: URL
        
        public init?(url: URL) {
            guard url.scheme(isAny: Self.schemes) else { return nil }
            self.url = url
        }
        
        // MARK: App Link
        
        public static var isDefaultApp: Bool { true }
        
        public static var schemes: [String] {
            ["x-apple-reminder", "x-apple-reminderkit", "reminders"]
        }
    }
}
