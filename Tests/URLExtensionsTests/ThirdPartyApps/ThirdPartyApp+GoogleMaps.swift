import Foundation
import Testing
@testable import URLExtensions

extension ThirdPartyAppTests {
    struct GoogleMaps {
        @Test func app() throws {
            let url = try #require(URL(string: "http://maps.google.com/?q=Mexican+Restaurant"))
            let app = try #require(url.app() as? URL.ThirdParty.GoogleMaps)

            #expect(app.parameters.query == "Mexican Restaurant")
        }

        @Test func initDefault() throws {
            let parameters = URL.ThirdParty.GoogleMapsParameter(query: "Cupertino")
            let url = URL.ThirdParty.googleMaps(parameters: parameters)

            #expect(url.scheme == "comgooglemaps")
            #expect(url.absoluteString == "comgooglemaps://?q=Cupertino")
        }

        @Test func initEmpty() throws {
            let parameters = URL.ThirdParty.GoogleMapsParameter()
            let url = URL.ThirdParty.googleMaps(parameters: parameters)

            #expect(url.scheme == "comgooglemaps")
            #expect(url.absoluteString == "comgooglemaps://?")
        }

        @Test func `init`() throws {
            let parameters = URL.ThirdParty.GoogleMapsParameter(query: "Cupertino")
            let url = URL.ThirdParty.googleMaps(parameters: parameters, preferUniversalLink: true)

            #expect(url.scheme == "https")
            #expect(url.absoluteString == "https://maps.google.com/?q=Cupertino")
        }

        @Test func query() throws {
            let url = try #require(URL(string: "http://maps.google.com/?q=Mexican+Restaurant"))
            let app = try #require(url.app() as? URL.ThirdParty.GoogleMaps)

            #expect(app.parameters.query == "Mexican Restaurant")
        }

        @Test func queryPlus() throws {
            let url = try #require(URL(string: "https://maps.google.com/?q=Steamers+Lane+Santa+Cruz,+CA&center=37.782652,-122.410126&views=satellite,traffic&zoom=15"))
            let app = try #require(url.app() as? URL.ThirdParty.GoogleMaps)

            #expect(app.parameters.query == "Steamers Lane Santa Cruz, CA")
            #expect(app.parameters.center?.latitude == 37.782652)
            #expect(app.parameters.center?.longitude == -122.410126)
            #expect(app.parameters.zoom == 15)
            #expect(app.parameters.views == [.satellite, .traffic])
        }

        @Test func navigation() throws {
            let url = try #require(URL(string: "http://maps.google.com/?saddr=Cupertino&daddr=San+Francisco"))
            let app = try #require(url.app() as? URL.ThirdParty.GoogleMaps)

            #expect(app.parameters.sourceAddress == "Cupertino")
            #expect(app.parameters.destinationAddress == "San Francisco")
        }

        @Test func navigationPlus() throws {
            let url = try #require(URL(string: "http://maps.google.com/?saddr=San+Jose&daddr=San+Francisco&directionsmode=transit"))
            let app = try #require(url.app() as? URL.ThirdParty.GoogleMaps)

            #expect(app.parameters.sourceAddress == "San Jose")
            #expect(app.parameters.destinationAddress == "San Francisco")
            #expect(app.parameters.directionsMode == .transit)
        }

        @Test func location() throws {
            let url = try #require(URL(string: "http://maps.google.com/?center=50.894967,4.341626"))
            let app = try #require(url.app() as? URL.ThirdParty.GoogleMaps)

            #expect(app.parameters.center == .init(latitude: 50.894967, longitude: 4.341626))
        }
    }
}
