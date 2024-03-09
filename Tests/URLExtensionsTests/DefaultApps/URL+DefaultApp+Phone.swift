import XCTest
@testable import URLExtensions

final class URL_DefaultApp_Phone: XCTestCase {
    func testInit() throws {
        let url = URL.phone(number: "1-408-555-5555")
        
        XCTAssertEqual(url.scheme, "tel")
        XCTAssertEqual(url.absoluteString, "tel:1-408-555-5555")
    }
    
    func testURL() throws {
        let url = try XCTUnwrap(URL(string: "tel:1-408-555-5555"))
        let app = try XCTUnwrap(url.app() as? URL.Phone)
        
        XCTAssertEqual(app.number, "1-408-555-5555")
    }
    
    func testEmtpyURL() throws {
        let url = try XCTUnwrap(URL(string: "tel:"))
        let app = try XCTUnwrap(url.app() as? URL.Phone)
        
        XCTAssertEqual(app.number, "")
    }
}
