import XCTest
@testable import URLExtensions

final class URL_DefaultApp_SMS: XCTestCase {
    func testInit() throws {
        let url = URL.sms(number: "1-408-555-5555")
        
        XCTAssertEqual(url.scheme, "sms")
        XCTAssertEqual(url.absoluteString, "sms:1-408-555-5555")
    }
    
    func testURL() throws {
        let url = try XCTUnwrap(URL(string: "sms:1-408-555-5555"))
        let app = try XCTUnwrap(url.app() as? URL.SMS)
        
        XCTAssertEqual(app.number, "1-408-555-5555")
    }
    
    func testEmtpyURL() throws {
        let url = try XCTUnwrap(URL(string: "sms:"))
        let app = try XCTUnwrap(url.app() as? URL.SMS)
        
        XCTAssertEqual(app.number, "")
    }
}
