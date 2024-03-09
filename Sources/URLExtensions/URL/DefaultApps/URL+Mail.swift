//
//  URL+Mail.swift
//  URL+Extensions
//
//  Created by David Walter on 10.07.23.
//

import Foundation
import OSLog

extension URL {
    public static func mail(email: String, parameters: MailParameter = MailParameter()) -> URL {
        // swiftlint:disable:next force_unwrapping
        var components = URLComponents(string: "mailto:\(email)")!
        
        do {
            components.queryItems = try URLQueryEncoder().encode(parameters)
        } catch {
            Logger.url.error("\(error.localizedDescription). This is a bug! Please file a report.")
        }
        
        guard let url = components.url else {
            fatalError("Unable to create valid URL. This is a bug! Please file a report.")
        }
        
        return url
    }
}

extension URL {
    // MARK: - App
    
    public struct Mail: Equatable, Hashable, Codable, AppLink {
        public let url: URL
        public let email: String
        public let parameters: MailParameter
        
        public init?(url: URL) {
            guard url.scheme(isAny: Self.schemes) else { return nil }
            self.url = url
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
            self.email = components.path
            guard let parameters = MailParameter(url: url) else { return nil }
            self.parameters = parameters
        }
        
        public init(email: String, parameters: MailParameter = .init()) {
            self.url = URL.mail(email: email, parameters: parameters)
            self.email = email
            self.parameters = parameters
        }
        
        // MARK: App Link
        
        public static var isDefaultApp: Bool { true }
        
        public static var schemes: [String] {
            ["mailto", "message"]
        }
    }
    
    // MARK: Parameter
    
    /// Mail URL Parameter
    ///
    /// See [Mail Links](https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/MailLinks/MailLinks.html) for more details.
    public struct MailParameter: Equatable, Hashable, Codable {
        var subject: String?
        var body: String?
        var carbonCopy: [String]?
        var blindCarbonCopy: [String]?
        
        public init?(url: URL) {
            if let query = url.internalQuery() {
                do {
                    self = try URLQueryDecoder().decode(MailParameter.self, from: query)
                } catch {
                    return nil
                }
            } else {
                return nil
            }
        }
        
        public init() {
        }
        
        // MARK: Codable
        
        enum CodingKeys: String, CodingKey {
            case subject = "subject"
            case body = "body"
            case carbonCopy = "cc"
            case blindCarbonCopy = "bcc"
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.subject = try container.decodeIfPresent(String.self, forKey: .subject)
            self.body = try container.decodeIfPresent(String.self, forKey: .body)
            let carbonCopy = try container.decodeIfPresent(String.self, forKey: .carbonCopy)
            self.carbonCopy = carbonCopy?.split(separator: ",").map { String($0) }
            let blindCarbonCopy = try container.decodeIfPresent(String.self, forKey: .blindCarbonCopy)
            self.blindCarbonCopy = blindCarbonCopy?.split(separator: ",").map { String($0) }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encodeIfPresent(self.subject, forKey: .subject)
            try container.encodeIfPresent(self.body, forKey: .body)
            try container.encodeIfPresent(self.carbonCopy?.joined(separator: ","), forKey: .carbonCopy)
            try container.encodeIfPresent(self.blindCarbonCopy?.joined(separator: ","), forKey: .blindCarbonCopy)
        }
    }
}
