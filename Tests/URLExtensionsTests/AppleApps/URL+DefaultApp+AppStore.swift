import XCTest
@testable import URLExtensions

final class URL_DefaultApp_AppStore: XCTestCase {
    func testInitDefault() throws {
        let parameters = URL.AppStoreParameter(id: 375380948)
        let url = URL.appStore(parameters: parameters)
        
        XCTAssertEqual(url.scheme, "itms-apps")
        XCTAssertEqual(url.absoluteString, "itms-apps://apps.apple.com/app/id375380948")
    }
    
    func testInit() throws {
        let parameters = URL.AppStoreParameter(id: 375380948)
        let url = URL.appStore(parameters: parameters, preferUniversalLink: true)
        
        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.absoluteString, "https://apps.apple.com/app/id375380948")
    }
    
    func testInitCountryCode() throws {
        let parameters = URL.AppStoreParameter(id: 375380948, countryCode: "at")
        let url = URL.appStore(parameters: parameters, preferUniversalLink: true)
        
        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.absoluteString, "https://apps.apple.com/at/app/id375380948")
    }
    
    func testiTunes() throws {
        let url = try XCTUnwrap(URL(string: "https://itunes.apple.com/us/app/apple-store/id375380948?mt=8"))
        let app = try XCTUnwrap(url.app() as? URL.AppStore)
        
        XCTAssertEqual(app.parameters.id, 375380948)
    }
    
    func testApps() throws {
        let url = try XCTUnwrap(URL(string: "https://apps.apple.com/us/app/apple-store/id375380948?mt=8"))
        let app = try XCTUnwrap(url.app() as? URL.AppStore)
        
        XCTAssertEqual(app.parameters.id, 375380948)
    }
    
    func testWithoutRegion() throws {
        let url = try XCTUnwrap(URL(string: "https://itunes.apple.com/app/apple-store/id375380948?mt=8"))
        let app = try XCTUnwrap(url.app() as? URL.AppStore)
        
        XCTAssertEqual(app.parameters.id, 375380948)
    }
}
