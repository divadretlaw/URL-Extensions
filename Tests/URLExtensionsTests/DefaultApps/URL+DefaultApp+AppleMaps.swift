import XCTest
@testable import URLExtensions

final class URL_DefaultApp_AppleMaps: XCTestCase {
    func testApp() throws {
        let url = try XCTUnwrap(URL(string: "http://maps.apple.com/?q=Mexican+Restaurant"))
        let app = try XCTUnwrap(url.app() as? URL.AppleMaps)
        
        XCTAssertEqual(app.parameters.query, "Mexican Restaurant")
    }
    
    func testInitDefault() throws {
        let parameters = URL.AppleMapsParameter(query: "Cupertino")
        let url = URL.appleMaps(parameters: parameters)
        
        XCTAssertEqual(url.scheme, "maps")
        XCTAssertEqual(url.absoluteString, "maps://?q=Cupertino")
    }
    
    func testInitEmpty() throws {
        let parameters = URL.AppleMapsParameter()
        let url = URL.appleMaps(parameters: parameters)
        
        XCTAssertEqual(url.scheme, "maps")
        XCTAssertEqual(url.absoluteString, "maps://?")
    }
    
    func testInit() throws {
        let parameters = URL.AppleMapsParameter(query: "Cupertino")
        let url = URL.appleMaps(parameters: parameters, preferUniversalLink: true)
        
        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.absoluteString, "https://maps.apple.com/?q=Cupertino")
    }
    
    func testQuery() throws {
        let url = try XCTUnwrap(URL(string: "http://maps.apple.com/?q=Mexican+Restaurant"))
        let app = try XCTUnwrap(url.app() as? URL.AppleMaps)
        
        XCTAssertEqual(app.parameters.query, "Mexican Restaurant")
    }
    
    func testQueryPlus() throws {
        let url = try XCTUnwrap(URL(string: "http://maps.apple.com/?q=Mexican+Restaurant&sll=50.894967,4.341626&z=10&t=k"))
        let app = try XCTUnwrap(url.app() as? URL.AppleMaps)
        
        XCTAssertEqual(app.parameters.query, "Mexican Restaurant")
        XCTAssertEqual(app.parameters.searchLocation?.latitude, 50.894967)
        XCTAssertEqual(app.parameters.searchLocation?.longitude, 4.341626)
        XCTAssertEqual(app.parameters.zoomLevel, 10)
        XCTAssertEqual(app.parameters.mapType, .satellite)
    }
    
    func testNavigation() throws {
        let url = try XCTUnwrap(URL(string: "http://maps.apple.com/?saddr=Cupertino&daddr=San+Francisco"))
        let app = try XCTUnwrap(url.app() as? URL.AppleMaps)
        
        XCTAssertEqual(app.parameters.sourceAddress, "Cupertino")
        XCTAssertEqual(app.parameters.destinationAddress, "San Francisco")
    }
    
    func testNavigationPlus() throws {
        let url = try XCTUnwrap(URL(string: "http://maps.apple.com/?saddr=San+Jose&daddr=San+Francisco&dirflg=r"))
        let app = try XCTUnwrap(url.app() as? URL.AppleMaps)
        
        XCTAssertEqual(app.parameters.sourceAddress, "San Jose")
        XCTAssertEqual(app.parameters.destinationAddress, "San Francisco")
        XCTAssertEqual(app.parameters.transportType, .publicTransport)
    }
    
    func testNavigationFromHerePlus() throws {
        let url = try XCTUnwrap(URL(string: "http://maps.apple.com/?daddr=San+Francisco&dirflg=d&t=h"))
        let app = try XCTUnwrap(url.app() as? URL.AppleMaps)
        
        XCTAssertNil(app.parameters.sourceAddress)
        XCTAssertEqual(app.parameters.destinationAddress, "San Francisco")
        XCTAssertEqual(app.parameters.transportType, .car)
        XCTAssertEqual(app.parameters.mapType, .hybrid)
    }
    
    func testLocation() throws {
        let url = try XCTUnwrap(URL(string: "http://maps.apple.com/?ll=50.894967,4.341626"))
        let app = try XCTUnwrap(url.app() as? URL.AppleMaps)
        
        XCTAssertEqual(app.parameters.location, .init(latitude: 50.894967, longitude: 4.341626))
    }
    
    func testAddress() throws {
        let url = try XCTUnwrap(URL(string: "http://maps.apple.com/?address=1,Infinite+Loop,Cupertino,California"))
        let app = try XCTUnwrap(url.app() as? URL.AppleMaps)
        
        XCTAssertEqual(app.parameters.address, "1,Infinite Loop,Cupertino,California")
    }
}
