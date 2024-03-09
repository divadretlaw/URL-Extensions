//
//  URL+AppStore.swift
//  URL+Extensions
//
//  Created by David Walter on 09.07.23.
//

import Foundation

extension URL {
    /// Creates a App Store URL instance from the provided data.
    ///
    /// - Parameters:
    ///   - parameters: The App Store Parameters. See ``AppStoreParameters``.
    ///   - preferUniversalLink: Whether to create the URL using the universal link or url scheme. Defaults to `false`.
    public static func appStore(parameters: AppStoreParameter, preferUniversalLink: Bool = false) -> URL {
        let path = [parameters.countryCode, "app", parameters.description]
            .compactMap { $0 }
            .joined(separator: "/")
        
        if preferUniversalLink {
            // swiftlint:disable:next force_unwrapping
            return URL(string: "https://apps.apple.com/\(path)")!
        } else {
            // swiftlint:disable:next force_unwrapping
            return URL(string: "itms-apps://apps.apple.com/\(path)")!
        }
    }
}

extension URL {
    // MARK: App
    
    public struct AppStore: Equatable, Hashable, Codable, AppLink {
        public let url: URL
        public let parameters: AppStoreParameter
        
        public init?(url: URL) {
            guard let parameters = AppStoreParameter(url: url) else { return nil }
            self.url = url
            self.parameters = parameters
        }
        
        public init(parameters: AppStoreParameter) {
            self.url = URL.appStore(parameters: parameters)
            self.parameters = parameters
        }
        
        // MARK: App Link
        
        public static var isDefaultApp: Bool { true }
        
        public static var schemes: [String] {
            ["itms-apps", "itms-appss", "macappstore", "macappstores"]
        }
        
        public static var hosts: [String]? {
            ["apps.apple.com", "itunes.apple.com"]
        }
        
        public static func check(against url: URL) -> Bool {
            AppStoreParameter(url: url) != nil
        }
    }
    
    // MARK: Parameter
    
    /// App Store URL Parameters
    ///
    /// See [App Store Links](https://developer.apple.com/library/archive/qa/qa1629/_index.html) for more details.
    public struct AppStoreParameter: Equatable, Hashable, Codable, CustomStringConvertible {
        /// The iTunes item identifier
        public var id: Int
        /// Optional country code
        public var countryCode: String?
        
        /// Initialize the App Store parameters from the given url
        ///
        /// - Parameter url: The url to parse
        ///
        /// Will be `nil` if the url does not represent valid App Store parameters
        public init?(url: URL) {
            guard url.scheme(isAny: AppStore.schemes + Browser.schemes) else { return nil }
            guard let hosts = AppStore.hosts, url.host(isAny: hosts) else { return nil }
            guard url.lastPathComponent.hasPrefix("id") else { return nil }
            
            let compontens = url.pathComponents
                .filter { $0 != "/" }
                .map { $0.lowercased() }
            
            guard compontens.contains("app") else { return nil}
            
            switch compontens.count {
            case 2:
                // No country code available
                break
            case 3, 4:
                // Country code is the first path component
                self.countryCode = compontens.first
            default:
                // Unsupported amount of path components
                return nil
            }
            
            guard let id = Int(url.lastPathComponent.dropFirst(2)) else { return nil }
            self.id = id
        }
        
        /// Initialize the App Store parameters
        ///
        /// - Parameters:
        ///   - id: The iTunes item identifier
        ///   - countryCode: Optional country code
        public init(id: Int, countryCode: String? = nil) {
            self.id = id
            self.countryCode = countryCode
        }
        
        // MARK: CustomStringConvertible
        
        /// Formatted iTunes item identifier
        public var description: String {
            "id\(id)"
        }
    }
}
