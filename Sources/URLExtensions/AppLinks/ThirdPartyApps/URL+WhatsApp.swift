//
//  URL+WhatsApp.swift
//  URL+Extensions
//
//  Created by David Walter on 10.07.23.
//

import Foundation
import OSLog

extension URL {
    public static func whatsApp(number: String? = nil, parameters: WhatsAppParameter? = nil, preferUniversalLink: Bool = false) -> URL {
        var components: URLComponents
        
        if preferUniversalLink {
            // swiftlint:disable:next force_unwrapping
            components = URLComponents(string: "https://wa.me/\(number?.whatsApped() ?? "")")!
        } else {
            // swiftlint:disable:next force_unwrapping
            components = URLComponents(string: "whatsapp://\(number?.whatsApped() ?? "")")!
        }
        
        if let parameters = parameters {
            do {
                components.queryItems = try URLQueryEncoder().encode(parameters)
            } catch {
                Logger.url.error("Error: \(error.localizedDescription). This is a bug! Please file a report.")
            }
        }
        
        guard let url = components.url else {
            fatalError("Unable to create valid URL. This is a bug! Please file a report.")
        }
        
        return url
    }
}

extension URL {
    // MARK: - App
    
    /// WhatsApp URL
    ///
    /// See [WhatsApp](https://faq.whatsapp.com/425247423114725/?locale=en_US&cms_platform=iphone)
    public struct WhatsApp: Equatable, Hashable, Codable, AppLink {
        public let url: URL
        public let number: String?
        public let parameters: WhatsAppParameter
        
        public init?(url: URL) {
            self.url = url
            
            if let hosts = WhatsApp.hosts, url.host(isAny: hosts), url.scheme(isAny: "https", "http") {
                let pathComponents = url.pathComponents.filter { $0 != "/" }
                self.number = pathComponents.first?.whatsApped()
            } else if url.scheme(isAny: WhatsApp.schemes) {
                self.number = url.internalHost()?.whatsApped()
            } else {
                return nil
            }
            
            if let query = url.internalQuery() {
                do {
                    self.parameters = try URLQueryDecoder().decode(WhatsAppParameter.self, from: query)
                } catch {
                    self.parameters = WhatsAppParameter()
                }
            } else {
                self.parameters = WhatsAppParameter()
            }
        }
        
        public init(number: String? = nil, parameters: WhatsAppParameter? = nil) {
            self.url = URL.whatsApp(number: number, parameters: parameters)
            self.number = number
            self.parameters = parameters ?? .init()
        }
        
        // MARK: App Link
        
        public static var isDefaultApp: Bool { false }
        
        public static var schemes: [String] {
            ["whatsapp"]
        }
        
        public static var hosts: [String]? {
            ["wa.me"]
        }
    }
    
    // MARK: - Parameter
    
    public struct WhatsAppParameter: Equatable, Hashable, Codable, Sendable {
        var text: String?
        
        public init(text: String? = nil) {
            self.text = text
        }
        
        // MARK: Codable
        
        enum CodingKeys: String, CodingKey {
            case text = "text"
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.text = try container.decodeIfPresent(String.self, forKey: .text)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encodeIfPresent(self.text, forKey: .text)
        }
    }
}

private extension String {
    func whatsApped() -> String {
        let number = self.removingCharacters(in: .decimalDigits.inverted)
        if let intValue = Int(number) {
            return intValue.description
        } else {
            return number
        }
    }
}
