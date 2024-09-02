//
//  URL+SMS.swift
//  URL+Extensions
//
//  Created by David Walter on 10.07.23.
//

import Foundation

extension URL {
    public static func sms(number: String) -> URL {
        // swiftlint:disable:next force_unwrapping
        return URL(string: "sms:\(number.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? number)")!
    }
}

extension URL {
    // MARK: - App
    
    /// SMS URL
    ///
    /// See [SMS](https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/SMSLinks/SMSLinks.html)
    public struct SMS: Equatable, Hashable, Codable, AppLink {
        public let url: URL
        public let number: String
        
        public init?(url: URL) {
            guard url.scheme(isAny: Self.schemes) else { return nil }
            self.url = url
            
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
            self.number = components.path
        }
        
        public init(number: String) {
            self.url = URL.sms(number: number)
            self.number = number
        }
        
        // MARK: App Link
        
        public static var isDefaultApp: Bool { true }
        
        public static var schemes: [String] {
            ["sms", "sms-private", "messages"]
        }
    }
}
