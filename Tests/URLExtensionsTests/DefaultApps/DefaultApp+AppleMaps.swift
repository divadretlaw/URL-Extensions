import Foundation
import Testing
@testable import URLExtensions

extension DefaultAppTests {
    struct AppleMaps {
        @Test func app() throws {
            let url = try #require(URL(string: "http://maps.apple.com/?q=Mexican+Restaurant"))
            let app = try #require(url.app() as? URL.AppleMaps)

            #expect(app.parameters.query == "Mexican Restaurant")
        }

        @Test func initDefault() throws {
            let parameters = URL.AppleMapsParameter(query: "Cupertino")
            let url = URL.appleMaps(parameters: parameters)

            #expect(url.scheme == "maps")
            #expect(url.absoluteString == "maps://?q=Cupertino")
        }

        @Test func initEmpty() throws {
            let parameters = URL.AppleMapsParameter()
            let url = URL.appleMaps(parameters: parameters)

            #expect(url.scheme == "maps")
            #expect(url.absoluteString == "maps://?")
        }

        @Test func `init`() throws {
            let parameters = URL.AppleMapsParameter(query: "Cupertino")
            let url = URL.appleMaps(parameters: parameters, preferUniversalLink: true)

            #expect(url.scheme == "https")
            #expect(url.absoluteString == "https://maps.apple.com/?q=Cupertino")
        }

        @Test func query() throws {
            let url = try #require(URL(string: "http://maps.apple.com/?q=Mexican+Restaurant"))
            let app = try #require(url.app() as? URL.AppleMaps)

            #expect(app.parameters.query == "Mexican Restaurant")
        }

        @Test func queryPlus() throws {
            let url = try #require(URL(string: "http://maps.apple.com/?q=Mexican+Restaurant&sll=50.894967,4.341626&z=10&t=k"))
            let app = try #require(url.app() as? URL.AppleMaps)

            #expect(app.parameters.query == "Mexican Restaurant")
            #expect(app.parameters.searchLocation?.latitude == 50.894967)
            #expect(app.parameters.searchLocation?.longitude == 4.341626)
            #expect(app.parameters.zoomLevel == 10)
            #expect(app.parameters.mapType == .satellite)
        }

        func navigation() throws {
            let url = try #require(URL(string: "http://maps.apple.com/?saddr=Cupertino&daddr=San+Francisco"))
            let app = try #require(url.app() as? URL.AppleMaps)

            #expect(app.parameters.sourceAddress == "Cupertino")
            #expect(app.parameters.destinationAddress == "San Francisco")
        }

        @Test func navigationPlus() throws {
            let url = try #require(URL(string: "http://maps.apple.com/?saddr=San+Jose&daddr=San+Francisco&dirflg=r"))
            let app = try #require(url.app() as? URL.AppleMaps)

            #expect(app.parameters.sourceAddress == "San Jose")
            #expect(app.parameters.destinationAddress == "San Francisco")
            #expect(app.parameters.transportType == .publicTransport)
        }

        @Test func navigationFromHerePlus() throws {
            let url = try #require(URL(string: "http://maps.apple.com/?daddr=San+Francisco&dirflg=d&t=h"))
            let app = try #require(url.app() as? URL.AppleMaps)

            #expect(app.parameters.sourceAddress == nil)
            #expect(app.parameters.destinationAddress == "San Francisco")
            #expect(app.parameters.transportType == .car)
            #expect(app.parameters.mapType == .hybrid)
        }

        @Test func location() throws {
            let url = try #require(URL(string: "http://maps.apple.com/?ll=50.894967,4.341626"))
            let app = try #require(url.app() as? URL.AppleMaps)

            #expect(app.parameters.location == .init(latitude: 50.894967, longitude: 4.341626))
        }

        @Test func address() throws {
            let url = try #require(URL(string: "http://maps.apple.com/?address=1,Infinite+Loop,Cupertino,California"))
            let app = try #require(url.app() as? URL.AppleMaps)

            #expect(app.parameters.address == "1,Infinite Loop,Cupertino,California")
        }
    }
}
