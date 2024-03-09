//
//  URL+AppLink.swift
//  URL+Extensions
//
//  Created by David Walter on 09.07.23.
//

import Foundation

public protocol AppLink: Sendable {
    /// Initialize this app link from the given url
    ///
    /// - Parameter url: The url to parse
    ///
    /// Will be `nil` if the given URL does not represent a valid app link
    init?(url: URL)
    
    /// Checks if the app link represents a default app.
    static var isDefaultApp: Bool { get }
    /// Checks if the app link represents a third-party app.
    static var isThirdPartyApp: Bool { get }
    
    /// The known schemes for this app
    static var schemes: [String] { get }
    /// The known url hosts for this app
    static var hosts: [String]? { get }
    
    /// Check if the given url represents this app link
    /// - Parameter url: The url to check against
    /// - Returns: `true` if the url represents this app link
    static func check(against url: URL) -> Bool
}

/// Default Implementations
public extension AppLink {
    static var isThirdPartyApp: Bool { !isDefaultApp }
    static var hosts: [String]? { nil }
    
    static func check(against url: URL) -> Bool {
        url.scheme(isAny: schemes)
    }
}

extension AppLink {
    static var canBeUniversalLink: Bool {
        hosts != nil
    }
}


extension URL {
    /// Evaluates the URL if it represents any known app link.
    ///
    /// - Returns: The app or `nil` if its not a known app.
    ///
    /// This will check any type registered in ``URl/AppLinkManager``
    public func app() -> (any AppLink)? {
        guard let scheme = scheme?.lowercased() else { return nil }
        
        if Browser.schemes.contains(scheme) {
            for appType in URL.appLinkManager.allUniversalLinkTypes {
                if let value = appType.init(url: self) {
                    return value
                }
            }
        } else {
            for appType in URL.appLinkManager.types {
                if let value = appType.init(url: self) {
                    return value
                }
            }
        }
        
        return nil
    }
}
