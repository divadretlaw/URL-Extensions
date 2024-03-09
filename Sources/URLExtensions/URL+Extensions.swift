//
//  URL+Extensions.swift
//  URL+Extensions
//
//  Created by David Walter on 08.01.23.
//

import Foundation

// MARK: - Public

public extension URL {
    /// Checks if the URL can be opened with Safari
    var supportsSafari: Bool {
        guard let scheme = scheme?.lowercased() else { return false }
        
        if Browser.schemes.contains(scheme) {
            return !Self.appLinkManager.allUniversalLinkTypes.contains { $0.check(against: self) }
        } else {
            return false
        }
    }
    
    /// Initialize with string. Uses `NSDataDetector` to detect the first valid link within the text.
    ///
    /// - Parameters:
    ///     - link: The link or text with a link to extract the URL from.
    ///     - scheme: The scheme to use, in case no scheme was extracted. Defaults to `https`.
    ///
    /// Returns `nil` if a `URL` cannot be formed with the string (for example, if the string contains characters that are illegal in a URL, or is an empty string).
    @_disfavoredOverload init?(link: String, scheme: String = "https") {
        let range = NSRange(location: 0, length: link.utf16.count)
        
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            
            let urls = detector
                .matches(in: link, options: [], range: range)
                .compactMap { $0.url }
            
            guard let url = urls.first else {
                self.init(string: link)
                return
            }
            
            if let scheme = url.scheme, !scheme.isEmpty {
                self = url
            } else {
                self.init(string: "\(scheme)://\(url.absoluteString)")
            }
        } catch {
            self.init(string: link)
        }
    }
    
    /// Initialize with string. Uses `NSDataDetector` to detect the first valid link within the text.
    ///
    /// - Parameters:
    ///     - link: The link or text with a link to extract the URL from.
    ///     - scheme: The scheme to use, in case no scheme was extracted. Defaults to `https`.
    ///     - encodingInvalidCharacters: True if `URL` should try to encode an invalid URL string, false otherwise.
    ///
    /// If `encodingInvalidCharacters` is false, and the detected link is invalid according to RFC 3986, `nil` is returned.
    /// If `encodingInvalidCharacters` is true, `URL` will try to encode the detected link to create a valid URL.
    /// If the URL string is still invalid after encoding, `nil` is returned.
    @available(macOS 14, iOS 17, watchOS 10, tvOS 17, visionOS 1, *)
    init?(link: String, scheme: String = "https", encodingInvalidCharacters: Bool = true) {
        let range = NSRange(location: 0, length: link.utf16.count)
        
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            
            let urls = detector
                .matches(in: link, options: [], range: range)
                .compactMap { $0.url }
            
            guard let url = urls.first else {
                self.init(string: link)
                return
            }
            
            if let scheme = url.scheme, !scheme.isEmpty {
                self = url
            } else {
                self.init(string: "\(scheme)://\(url.absoluteString)")
            }
        } catch {
            self.init(string: link, encodingInvalidCharacters: encodingInvalidCharacters)
        }
    }
}

// MARK: - Internal

extension URL {
    internal func host(isAny hosts: String...) -> Bool {
        guard let host = internalHost()?.lowercased() else { return false }
        return hosts.contains { host == $0 }
    }
    
    internal func host(isAny hosts: [String]) -> Bool {
        guard let host = internalHost()?.lowercased() else { return false }
        return hosts.contains { host == $0 }
    }
    
    internal func scheme(isAny schemes: String...) -> Bool {
        guard let scheme = scheme?.lowercased() else { return false }
        return schemes.contains { scheme == $0 }
    }
    
    internal func scheme(isAny schemes: [String]) -> Bool {
        guard let scheme = scheme?.lowercased() else { return false }
        return schemes.contains { scheme == $0 }
    }
    
    internal func internalHost() -> String? {
        if #available(macOS 13, iOS 16, watchOS 9, tvOS 16, visionOS 1, *) {
            return host(percentEncoded: false)
        } else {
            return host
        }
    }
    
    internal func internalQuery() -> String? {
        if #available(macOS 13, iOS 16, watchOS 9, tvOS 16, visionOS 1, *) {
            return query(percentEncoded: false)
        } else {
            return query
        }
    }
}
