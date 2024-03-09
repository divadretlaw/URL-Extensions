//
//  URL+AppleMaps.swift
//  URL+Extensions
//
//  Created by David Walter on 06.07.23.
//

import Foundation
import OSLog

extension URL {
    /// Creates a Apple Maps URL instance from the provided data.
    ///
    /// - Parameters:
    ///   - parameters: The Apple Maps Parameters. See ``AppleMapsParameter``.
    ///   - preferUniversalLink: Whether to create the URL using the universal link or url scheme. Defaults to `false`.
    public static func appleMaps(parameters: AppleMapsParameter, preferUniversalLink: Bool = false) -> URL {
        var components: URLComponents
        
        if preferUniversalLink {
            // swiftlint:disable:next force_unwrapping
            components = URLComponents(string: "https://maps.apple.com/")!
        } else {
            // swiftlint:disable:next force_unwrapping
            components = URLComponents(string: "maps://")!
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
    
    public struct AppleMaps: Equatable, Hashable, Codable, AppLink {
        public let url: URL
        public let parameters: AppleMapsParameter
        
        public init?(url: URL) {
            guard let parameters = AppleMapsParameter(url: url) else { return nil }
            self.url = url
            self.parameters = parameters
        }
        
        public init(parameters: AppleMapsParameter) {
            self.url = URL.appleMaps(parameters: parameters)
            self.parameters = parameters
        }
        
        // MARK: App Link
        
        public static var isDefaultApp: Bool { true }
        
        public static var schemes: [String] {
            ["maps", "map", "map-item"]
        }
        
        public static var hosts: [String]? {
            ["maps.apple.com", "guides.apple.com", "collections.apple.com"]
        }
        
        public static func check(against url: URL) -> Bool {
            AppleMapsParameter(url: url) != nil
        }
    }
    
    // MARK: - Parameter
    
    /// Apple Maps URL Parameters
    ///
    /// See [Map Links](https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html) for more details.
    public struct AppleMapsParameter: Equatable, Hashable, Codable, Sendable {
        /// The map type. If you don’t specify one of the documented values, the current map type is used.
        public var mapType: MapType?
        /// The query. This parameter is treated as if its value had been typed into the Maps search field by the user.
        /// The ``query`` parameter can also be used as a label if the location is explicitly defined in the ``location`` or ``address`` parameters.
        ///
        /// Note that "\*" is not supported
        public var query: String?
        /// The address. Using the ``address`` parameter simply displays the specified location, it does not perform a search for the location.
        public var address: String?
        /// A hint used during search. If the ``searchLocation`` parameter is missing or its value is incomplete, the value of ``near`` is used instead.
        public var near: Coordinate?
        /// The location around which the map should be centered.
        /// The ``location`` parameter can also represent a pin location when you use the ``query`` parameter to specify a name.
        public var location: Coordinate?
        /// The zoom level. You can use the ``zoomLevel`` parameter only when you also use the ``location`` parameter; in particular,
        /// you can't use ``zoomLevel`` in combination with the ``span`` or ``screenSpan`` parameters.
        public var zoomLevel: Double?
        /// The area around the center point, or span. The center point is specified by the ``location`` parameter.
        /// You can’t use the ``span`` parameter in combination with the ``zoomLevel`` parameter.
        public var span: CoordinateSpan?
        /// The source address to be used as the starting point for directions.
        ///
        /// A complete directions request includes the ``sourceAddress``, ``destinationAddress``, and ``transportType`` parameters,
        /// but only the ``destinationAddress`` parameter is required. If you don’t specify a value for ``sourceAddress``, the starting point is "here."
        public var sourceAddress: String?
        /// The destination address to be used as the destination point for directions.
        ///
        /// A complete directions request includes the ``sourceAddress``, ``destinationAddress``, and ``transportType`` parameters,
        /// but only the ``destinationAddress`` parameter is required.
        public var destinationAddress: String?
        /// The transport type.
        ///
        /// A complete directions request includes the ``sourceAddress``, ``destinationAddress``, and ``transportType`` parameters,
        /// but only the ``destinationAddress`` parameter is required. If you don’t specify one of the documented transport type values,
        /// the ``transportType`` parameter is ignored; if you don’t specify any value, Maps uses the user’s preferred transport type or the previous setting.
        public var transportType: TransportType?
        /// The search location. You can specify the ``searchLocation`` parameter by itself or in combination with the ``query`` parameter.
        ///
        /// For example, http://maps.apple.com/?sll=50.894967,4.341626&z=10&t=s is a valid query.
        public var searchLocation: Coordinate?
        /// The screen span. Use the ``screenSpan`` parameter to specify a span around the search location specified by the ``searchLocation`` parameter.
        public var screenSpan: CoordinateSpan?
        
        /// Initialize the Apple Maps parameters from the given url
        ///
        /// - Parameter url: The url to parse
        ///
        /// Will be `nil` if the url does not represent valid Apple Maps parameters
        public init?(url: URL) {
            if let hosts = AppleMaps.hosts, url.scheme(isAny: "https", "http") {
                guard url.host(isAny: hosts), let query = url.internalQuery() else { return nil }
                do {
                    self = try URLQueryDecoder().decode(AppleMapsParameter.self, from: query)
                } catch {
                    return nil
                }
            } else if url.scheme(isAny: AppleMaps.schemes) {
                if let query = url.internalQuery() {
                    do {
                        self = try URLQueryDecoder().decode(AppleMapsParameter.self, from: query)
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
        
        /// Initialize the Apple Maps parameters
        public init(
            mapType: MapType? = nil,
            query: String? = nil,
            address: String? = nil,
            near: Coordinate? = nil,
            location: Coordinate? = nil,
            zoomLevel: Double? = nil,
            span: CoordinateSpan? = nil,
            sourceAddress: String? = nil,
            destinationAddress: String? = nil,
            transportType: TransportType? = nil,
            searchLocation: Coordinate? = nil,
            screenSpan: CoordinateSpan? = nil
        ) {
            self.mapType = mapType
            self.query = query
            self.address = address
            self.near = near
            self.location = location
            self.zoomLevel = zoomLevel
            self.span = span
            self.sourceAddress = sourceAddress
            self.destinationAddress = destinationAddress
            self.transportType = transportType
            self.searchLocation = searchLocation
            self.screenSpan = screenSpan
        }
        
        // MARK: Codable
        
        enum CodingKeys: String, CodingKey {
            case mapType = "t"
            case query = "q"
            case address = "address"
            case near = "near"
            case location = "ll"
            case zoomLevel = "z"
            case span = "spn"
            case sourceAddress = "saddr"
            case destinationAddress = "daddr"
            case transportType = "dirflg"
            case searchLocation = "sll"
            case screenSpan = "sspn"
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: URL.AppleMapsParameter.CodingKeys.self)
            
            self.mapType = try container.decodeIfPresent(MapType.self, forKey: .mapType)
            self.query = try container.decodeIfPresent(String.self, forKey: .query)
            self.address = try container.decodeIfPresent(String.self, forKey: .address)
            self.near = try container.decodeIfPresent(Coordinate.self, forKey: .near)
            self.location = try container.decodeIfPresent(Coordinate.self, forKey: .location)
            do {
                self.zoomLevel = try container.decodeIfPresent(Double.self, forKey: .zoomLevel)
            } catch DecodingError.typeMismatch {
                self.zoomLevel = Double(try container.decode(Int.self, forKey: .zoomLevel))
            } catch {
                print(error.localizedDescription)
            }
            self.sourceAddress = try container.decodeIfPresent(String.self, forKey: .sourceAddress)
            self.destinationAddress = try container.decodeIfPresent(String.self, forKey: .destinationAddress)
            self.transportType = try container.decodeIfPresent(TransportType.self, forKey: .transportType)
            self.searchLocation = try container.decodeIfPresent(Coordinate.self, forKey: .searchLocation)
            self.screenSpan = try container.decodeIfPresent(CoordinateSpan.self, forKey: .screenSpan)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encodeIfPresent(self.mapType, forKey: .mapType)
            try container.encodeIfPresent(self.query, forKey: .query)
            try container.encodeIfPresent(self.address, forKey: .address)
            try container.encodeIfPresent(self.near, forKey: .near)
            try container.encodeIfPresent(self.location, forKey: .location)
            try container.encodeIfPresent(self.zoomLevel, forKey: .zoomLevel)
            try container.encodeIfPresent(self.sourceAddress, forKey: .sourceAddress)
            try container.encodeIfPresent(self.destinationAddress, forKey: .destinationAddress)
            try container.encodeIfPresent(self.transportType, forKey: .transportType)
            try container.encodeIfPresent(self.searchLocation, forKey: .searchLocation)
            try container.encodeIfPresent(self.screenSpan, forKey: .screenSpan)
        }
    }
}

// MARK: - Subtypes

extension URL.AppleMapsParameter {
    /// The map type used in Apple Maps
    public enum MapType: String, Equatable, Hashable, Codable, Sendable {
        /// standard view
        case standard = "m"
        /// satellite view
        case satellite = "k"
        /// hybrid view
        case hybrid = "h"
        /// transit view
        case transit = "r"
    }
    
    /// The transport type used in Apple Maps
    public enum TransportType: String, Equatable, Hashable, Codable, Sendable {
        /// by car
        case car = "d"
        /// by foot
        case foot = "w"
        /// by public transport
        case publicTransport = "r"
    }
    
    public struct CoordinateSpan: Equatable, Hashable, Codable, Sendable {
        public var latitudeDelta: Double
        public var longitudeDelta: Double
        
        public init(latitudeDelta: Double, longitudeDelta: Double) {
            self.latitudeDelta = latitudeDelta
            self.longitudeDelta = longitudeDelta
        }
        
        // MARK: Codable
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            let string = try container.decode(String.self)
            let components = string.split(separator: ",")
            guard let latitudeDelta = Double(components[safe: 0]), let longitudeDelta = Double(components[safe: 1]) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Data must a comma-separated pair of floating point values that represent latitude and longitude (in that order).", underlyingError: nil))
            }
            self.latitudeDelta = latitudeDelta
            self.longitudeDelta = longitudeDelta
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode("\(latitudeDelta),\(longitudeDelta)")
        }
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
        guard let string = string else { return nil }
        guard let value = Double(string) else { return nil }
        self = value
    }
}
