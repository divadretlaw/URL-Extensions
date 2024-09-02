//
//  URL+Phone.swift
//  URL+Extensions
//
//  Created by David Walter on 10.07.23.
//

import Foundation

extension URL {
    public static func phone(number: String, prompt: Bool = false) -> URL {
        if prompt {
            URL.phone(tab: .callPrompt(number))
        } else {
            URL.phone(tab: .call(number))
        }
    }
    
    public static func phone(tab: Phone.Tab) -> URL {
        // swiftlint:disable:next force_unwrapping
        return URL(string: "\(tab.scheme)")!
    }
}

extension URL {
    // MARK: - App
    
    /// Phone URL
    ///
    /// See [Phone](https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/PhoneLinks/PhoneLinks.html)
    public struct Phone: Equatable, Hashable, Codable, AppLink {
        public let url: URL
        public let tab: Tab
        
        public init?(url: URL) {
            guard url.scheme(isAny: Self.schemes) else { return nil }
            self.url = url
            
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
            
            switch components.scheme {
            case "mobilephone-favorites":
                self.tab = .favorites
            case "mobilephone-recents":
                self.tab = .recents
            case "vmshow":
                self.tab = .voicemail
            default:
                self.tab = .call(components.path)
            }
        }
        
        public init(number: String) {
            self.url = URL.phone(number: number)
            self.tab = .call(number)
        }
        
        public init(tab: Tab) {
            // swiftlint:disable:next force_unwrapping
            self.url = URL(string: tab.scheme)!
            self.tab = tab
        }
        
        public var number: String {
            switch tab {
            case let .call(number):
                number
            case let .callPrompt(number):
                number
            default:
                ""
            }
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
    public enum Tab: Hashable, Equatable, Codable, Sendable {
        case call(String)
        case callPrompt(String)
        case sos
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
            case .sos:
                return "telsos:"
            case let .call(number):
                return "tel:\(number.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? number)"
            case let .callPrompt(number):
                return "telprompt:\(number.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? number)"
            }
        }
    }
}
