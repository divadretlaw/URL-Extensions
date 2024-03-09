//
//  URL+FaceTime.swift
//  URL+Extensions
//
//  Created by David Walter on 10.07.23.
//

import Foundation

extension URL {
    /// Creates a FaceTime URL instance from the provided data.
    ///
    /// - Parameters:
    ///   - user: The user to call
    ///   - audio: Whether the call should be audio only. Defaults to `false`.
    ///   - prompt: Whether the call should be a prompt. Defaults to `false`.
    public static func faceTime(user: String, audio: Bool = false, prompt: Bool = false) -> URL {
        let scheme = [
            "facetime",
            audio ? "audio" : nil,
            prompt ? "prompt" : nil
        ]
        .compactMap { $0 }
        .joined(separator: "-")
        
        // swiftlint:disable:next force_unwrapping
        return URL(string: "\(scheme)://\(user.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? user)")!
    }
}

extension URL {
    // MARK: - App
    
    /// FaceTime URL
    /// 
    /// See [Face Time](https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/FacetimeLinks/FacetimeLinks.html)
    public struct FaceTime: Equatable, Hashable, Codable, AppLink {
        public let url: URL
        public let user: String
        
        public init?(url: URL) {
            guard url.scheme(isAny: FaceTime.schemes) else { return nil }
            self.url = url
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
            self.user = components.path
        }
        
        public init(number: String) {
            self.url = URL.faceTime(user: number)
            self.user = number
        }
        
        // MARK: App Link
        
        public static var isDefaultApp: Bool { true }
        
        public static var schemes: [String] {
            ["facetime", "facetime-audio", "facetime-prompt", "facetime-audio-prompt"]
        }
    }
}
