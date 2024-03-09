//
//  URL+Phone.swift
//  URL+Extensions
//
//  Created by David Walter on 10.07.23.
//

import Foundation

extension URL {
    public static func phone(number: String, prompt: Bool = false) -> URL {
        let scheme = [
            "tel",
            prompt ? "prompt" : nil
        ]
            .compactMap { $0 }
            .joined()
        
        // swiftlint:disable:next force_unwrapping
        return URL(string: "\(scheme):\(number.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? number)")!
    }
}

extension URL {
    // MARK: - App
    
    /// Phone URL
    ///
    /// See [Phone](https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/PhoneLinks/PhoneLinks.html)
    public struct Phone: Equatable, Hashable, Codable, AppLink {
        public let url: URL
        public let number: String
        public let tab: Tab
        
        public init?(url: URL) {
            guard url.scheme(isAny: Self.schemes) else { return nil }
            self.url = url
            
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
            self.number = components.path
            
            switch components.scheme {
            case "mobilephone-favorites":
                self.tab = .favorites
            case "mobilephone-recents":
                self.tab = .recents
            case "vmshow":
                self.tab = .voicemail
            default:
                self.tab = .call
            }
        }
        
        public init(number: String) {
            self.url = URL.phone(number: number)
            self.number = number
            self.tab = .call
        }
        
        public init(tab: Tab) {
            // swiftlint:disable:next force_unwrapping
            self.url = URL(string: tab.scheme)!
            self.number = ""
            self.tab = tab
        }
        
        // MARK: App Link
        
        public static var isDefaultApp: Bool { true }
        
        public static var schemes: [String] {
            ["tel", "telprompt", "telsos", "mobilephone", "mobilephone-favorites", "mobilephone-recents", "vmshow"]
        }
    }
}

// MARK: - Subtypes

extension URL.Phone {
    public enum Tab: Int, Codable, Sendable {
        case call
        case favorites
        case recents
        case voicemail
        
        var scheme: String {
            switch self {
            case .favorites:
                return "mobilephone-favorites://"
            case .recents:
                return "mobilephone-recents://"
            case .voicemail:
                return "vmshow://"
            default:
                return "tel:"
            }
        }
    }
}
