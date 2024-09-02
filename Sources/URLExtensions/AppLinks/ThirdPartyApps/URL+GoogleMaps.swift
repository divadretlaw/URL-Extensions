//
//  URL+GoogleMaps.swift
//  URL+Extensions
//
//  Created by David Walter on 02.09.23.
//

import Foundation
import OSLog

extension URL {
    /// Creates a Google Maps URL instance from the provided data.
    ///
    /// - Parameters:
    ///   - parameters: The Google Maps Parameters. See ``GoogleMapsParameter``.
    ///   - preferUniversalLink: Whether to create the URL using the universal link or url scheme. Defaults to `false`.
    public static func googleMaps(parameters: GoogleMapsParameter, preferUniversalLink: Bool = false) -> URL {
        var components: URLComponents
        
        if preferUniversalLink {
            // swiftlint:disable:next force_unwrapping
            components = URLComponents(string: "https://maps.google.com/")!
        } else {
            // swiftlint:disable:next force_unwrapping
            components = URLComponents(string: "comgooglemaps://")!
        }
        
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
    
    public struct GoogleMaps: Equatable, Hashable, Codable, AppLink {
        public let url: URL
        public let parameters: GoogleMapsParameter
        
        public init?(url: URL) {
            guard let parameters = GoogleMapsParameter(url: url) else { return nil }
            self.url = url
            self.parameters = parameters
        }
        
        public init(parameters: GoogleMapsParameter) {
            self.url = URL.googleMaps(parameters: parameters)
            self.parameters = parameters
        }
        
        // MARK: App Link
        
        public static var isDefaultApp: Bool { false }
        
        public static var schemes: [String] {
            ["comgooglemaps", "comgooglemapsurl", "googlemaps", "comgooglemaps-x-callback"]
        }
        
        public static var hosts: [String]? {
            ["maps.google.com"]
        }
        
        public static func check(against url: URL) -> Bool {
            GoogleMapsParameter(url: url) != nil
        }
    }
    
    // MARK: - Parameter
    
    /// Google Maps URL Parameters
    ///
    /// See [Map URLs](https://developers.google.com/maps/documentation/urls/ios-urlscheme) for more details.
    public struct GoogleMapsParameter: Equatable, Hashable, Codable, Sendable {
        public var query: String?
        public var center: Coordinate?
        public var mapMode: MapMode?
        public var zoom: Double?
        public var views: Views?
        
        public var sourceAddress: String?
        public var destinationAddress: String?
        public var directionsMode: DirectionsMode?
        
        public init?(url: URL) {
            if let hosts = GoogleMaps.hosts, url.scheme(isAny: "https", "http") {
                guard url.host(isAny: hosts), let query = url.internalQuery() else { return nil }
                do {
                    self = try URLQueryDecoder().decode(GoogleMapsParameter.self, from: query)
                } catch {
                    return nil
                }
            } else if url.scheme(isAny: GoogleMaps.schemes) {
                if let query = url.internalQuery() {
                    do {
                        self = try URLQueryDecoder().decode(GoogleMapsParameter.self, from: query)
                    } catch {
                        return nil
                    }
                } else {
                    self.init()
                }
            } else {
                return nil
            }
        }
        
        public init(
            query: String? = nil,
            center: Coordinate? = nil,
            mapMode: MapMode? = nil,
            zoom: Double? = nil,
            views: Views? = nil,
            sourceAddress: String? = nil,
            destinationAddress: String? = nil,
            directionsMode: DirectionsMode? = nil
        ) {
            self.query = query
            self.center = center
            self.mapMode = mapMode
            self.zoom = zoom
            self.views = views
            self.sourceAddress = sourceAddress
            self.destinationAddress = destinationAddress
            self.directionsMode = directionsMode
        }
        
        // MARK: Codable
        
        enum CodingKeys: String, CodingKey {
            case query = "q"
            case center = "center"
            case mapMode = "mapmode"
            case zoom = "zoom"
            case views = "views"
            case sourceAddress = "saddr"
            case destinationAddress = "daddr"
            case directionsMode = "directionsmode"
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.query = try container.decodeIfPresent(String.self, forKey: .query)
            self.center = try container.decodeIfPresent(Coordinate.self, forKey: .center)
            self.mapMode = try container.decodeIfPresent(MapMode.self, forKey: .mapMode)
            do {
                self.zoom = try container.decodeIfPresent(Double.self, forKey: .zoom)
            } catch DecodingError.typeMismatch {
                self.zoom = Double(try container.decode(Int.self, forKey: .zoom))
            } catch {
                print(error.localizedDescription)
            }
            self.views = try container.decodeIfPresent(Views.self, forKey: .views)
            self.sourceAddress = try container.decodeIfPresent(String.self, forKey: .sourceAddress)
            self.destinationAddress = try container.decodeIfPresent(String.self, forKey: .destinationAddress)
            self.directionsMode = try container.decodeIfPresent(DirectionsMode.self, forKey: .directionsMode)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encodeIfPresent(self.query, forKey: .query)
            try container.encodeIfPresent(self.center, forKey: .center)
            try container.encodeIfPresent(self.mapMode, forKey: .mapMode)
            try container.encodeIfPresent(self.zoom, forKey: .zoom)
            try container.encodeIfPresent(self.views, forKey: .views)
            try container.encodeIfPresent(self.sourceAddress, forKey: .sourceAddress)
            try container.encodeIfPresent(self.destinationAddress, forKey: .destinationAddress)
            try container.encodeIfPresent(self.directionsMode, forKey: .directionsMode)
        }
    }
}

extension URL.GoogleMapsParameter {
    public enum MapMode: String, Equatable, Hashable, Codable, Sendable {
        /// standard view
        case standard = "standard"
        /// street view
        case streetview = "streetview"
    }
    
    public struct Views: OptionSet, Equatable, Hashable, Codable, Sendable {
        public var rawValue: Set<String>
        
        /// satellite view
        public static let satellite = Views(rawValue: ["satellite"])
        /// traffic view
        public static let traffic = Views(rawValue: ["traffic"])
        /// transit view
        public static let transit = Views(rawValue: ["transit"])
        
        public init(rawValue: Set<String>) {
            self.rawValue = rawValue
        }
        
        public init() {
            self.rawValue = []
        }
        
        public mutating func formUnion(_ other: Views) {
            rawValue = rawValue.union(other.rawValue)
        }
        
        public mutating func formIntersection(_ other: Views) {
            rawValue = rawValue.intersection(other.rawValue)
        }
        
        public mutating func formSymmetricDifference(_ other: Views) {
            rawValue = rawValue.symmetricDifference(other.rawValue)
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            let rawValue = try container.decode(String.self)
            self.rawValue = Set(rawValue.split(separator: ",").map { String($0) })
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            
            try container.encode(self.rawValue.joined(separator: ","))
        }
    }
    
    public enum DirectionsMode: String, Equatable, Hashable, Codable, Sendable {
        case driving = "driving"
        case transit = "transit"
        case bicycling = "bicycling"
        case walking = "walking"
    }
    
    public struct Coordinate: Equatable, Hashable, Codable, Sendable {
        public var latitude: Double
        public var longitude: Double
        
        public init(latitude: Double, longitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
        }
        
        // MARK: Codable
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            let string = try container.decode(String.self)
            let components = string.split(separator: ",")
            guard let latitude = Double(components[safe: 0]), let longitude = Double(components[safe: 1]) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Data must a comma-separated pair of floating point values that represent latitude and longitude (in that order).", underlyingError: nil))
            }
            self.latitude = latitude
            self.longitude = longitude
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode("\(latitude),\(longitude)")
        }
    }
}

// MARK: - Helper

private extension Double {
    init?(_ string: String.SubSequence?) {
        guard let string else { return nil }
        guard let value = Double(string) else { return nil }
        self = value
    }
}
