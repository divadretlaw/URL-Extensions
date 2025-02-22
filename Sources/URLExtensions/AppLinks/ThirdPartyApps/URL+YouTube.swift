//
//  URL+YouTube.swift
//  URL+Extensions
//
//  Created by David Walter on 10.07.23.
//

import Foundation

extension URL.ThirdParty {
    public static func youTube(videoIdentifier: String, preferUniversalLink: Bool = false) -> URL {
        if preferUniversalLink {
            // swiftlint:disable:next force_unwrapping
            var components = URLComponents(string: "https://youtube.com/watch")!
            components.queryItems = [URLQueryItem(name: "v", value: videoIdentifier)]
            
            guard let url = components.url else {
                fatalError("Unable to create valid URL. This is a bug! Please file a report.")
            }
            
            return url
        } else {
            // swiftlint:disable:next force_unwrapping
            return URL(string: "youtube://\(videoIdentifier.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? videoIdentifier)")!
        }
    }
    
    // MARK: - App
    
    /// YouTube URL
    ///
    /// See [YouTube](https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/YouTubeLinks/YouTubeLinks.html)
    public struct YouTube: Equatable, Hashable, Codable, AppLink {
        public let url: URL
        public let videoIdentifier: String
        
        public init?(url: URL) {
            self.url = url
            if let hosts = YouTube.hosts, url.scheme(isAny: "https", "http") {
                guard url.host(isAny: hosts) else { return nil }
                
                guard let host = url.internalHost() else { return nil }
                
                switch host {
                case "youtu.be":
                    self.videoIdentifier = url.lastPathComponent
                default:
                    let pathComponents = url.pathComponents.filter { $0 != "/" }
                    if pathComponents.first == "v" {
                        self.videoIdentifier = url.lastPathComponent
                    } else if pathComponents.first == "watch", let query = url.internalQuery() {
                        do {
                            let parameter = try URLQueryDecoder().decode(YouTubeParameter.self, from: query)
                            self.videoIdentifier = parameter.videoIdentifier
                        } catch {
                            return nil
                        }
                    } else {
                        return nil
                    }
                }
            } else if url.scheme(isAny: YouTube.schemes) {
                guard let videoIdentifier = url.internalHost() else { return nil }
                self.videoIdentifier = videoIdentifier
            } else {
                return nil
            }
        }
        
        public init(videoIdentifier: String) {
            self.url = URL.ThirdParty.youTube(videoIdentifier: videoIdentifier)
            self.videoIdentifier = videoIdentifier
        }
        
        // MARK: App Link
        
        public static var isDefaultApp: Bool { false }
        
        public static var schemes: [String] {
            ["youtube"]
        }
        
        public static var hosts: [String]? {
            ["youtube.com", "www.youtube.com", "youtu.be"]
        }
    }
    
    // MARK: - Parameter
    
    /// YouTube URL Parameters
    ///
    /// See [YouTube](https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/YouTubeLinks/YouTubeLinks.html) for more details.
    struct YouTubeParameter: Equatable, Hashable, Codable {
        var videoIdentifier: String
        
        // MARK: Codable
        
        enum CodingKeys: String, CodingKey {
            case videoIdentifier = "v"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.videoIdentifier = try container.decode(String.self, forKey: .videoIdentifier)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(self.videoIdentifier, forKey: .videoIdentifier)
        }
    }
}
