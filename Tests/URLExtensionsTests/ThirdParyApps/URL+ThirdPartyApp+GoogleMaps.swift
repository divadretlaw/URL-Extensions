import XCTest
@testable import URLExtensions

final class URL_ThirdPartyApp_GoogleMaps: XCTestCase {
    func testApp() throws {
        let url = try XCTUnwrap(URL(string: "http://maps.google.com/?q=Mexican+Restaurant"))
        let app = try XCTUnwrap(url.app() as? URL.GoogleMaps)
        
        XCTAssertEqual(app.parameters.query, "Mexican Restaurant")
    }
    
    func testInitDefault() throws {
        let parameters = URL.GoogleMapsParameter(query: "Cupertino")
        let url = URL.googleMaps(parameters: parameters)
        
        XCTAssertEqual(url.scheme, "comgooglemaps")
        XCTAssertEqual(url.absoluteString, "comgooglemaps://?q=Cupertino")
    }
    
    func testInitEmpty() throws {
        let parameters = URL.GoogleMapsParameter()
        let url = URL.googleMaps(parameters: parameters)
        
        XCTAssertEqual(url.scheme, "comgooglemaps")
        XCTAssertEqual(url.absoluteString, "comgooglemaps://?")
    }
    
    func testInit() throws {
        let parameters = URL.GoogleMapsParameter(query: "Cupertino")
        let url = URL.googleMaps(parameters: parameters, preferUniversalLink: true)
        
        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.absoluteString, "https://maps.google.com/?q=Cupertino")
    }
    
    func testQuery() throws {
        let url = try XCTUnwrap(URL(string: "http://maps.google.com/?q=Mexican+Restaurant"))
        let app = try XCTUnwrap(url.app() as? URL.GoogleMaps)
        
        XCTAssertEqual(app.parameters.query, "Mexican Restaurant")
    }
    
    func testQueryPlus() throws {
        let url = try XCTUnwrap(URL(string: "https://maps.google.com/?q=Steamers+Lane+Santa+Cruz,+CA&center=37.782652,-122.410126&views=satellite,traffic&zoom=15"))
        let app = try XCTUnwrap(url.app() as? URL.GoogleMaps)
        
        XCTAssertEqual(app.parameters.query, "Steamers Lane Santa Cruz, CA")
        XCTAssertEqual(app.parameters.center?.latitude, 37.782652)
        XCTAssertEqual(app.parameters.center?.longitude, -122.410126)
        XCTAssertEqual(app.parameters.zoom, 15)
        XCTAssertEqual(app.parameters.views, [.satellite, .traffic])
    }
    
    func testNavigation() throws {
        let url = try XCTUnwrap(URL(string: "http://maps.google.com/?saddr=Cupertino&daddr=San+Francisco"))
        let app = try XCTUnwrap(url.app() as? URL.GoogleMaps)
        
        XCTAssertEqual(app.parameters.sourceAddress, "Cupertino")
        XCTAssertEqual(app.parameters.destinationAddress, "San Francisco")
    }
    
    func testNavigationPlus() throws {
        let url = try XCTUnwrap(URL(string: "http://maps.google.com/?saddr=San+Jose&daddr=San+Francisco&directionsmode=transit"))
        let app = try XCTUnwrap(url.app() as? URL.GoogleMaps)
        
        XCTAssertEqual(app.parameters.sourceAddress, "San Jose")
        XCTAssertEqual(app.parameters.destinationAddress, "San Francisco")
        XCTAssertEqual(app.parameters.directionsMode, .transit)
    }
    
    func testLocation() throws {
        let url = try XCTUnwrap(URL(string: "http://maps.google.com/?center=50.894967,4.341626"))
        let app = try XCTUnwrap(url.app() as? URL.GoogleMaps)
        
        XCTAssertEqual(app.parameters.center, .init(latitude: 50.894967, longitude: 4.341626))
    }
}
