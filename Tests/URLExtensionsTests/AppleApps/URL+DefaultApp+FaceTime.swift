import XCTest
@testable import URLExtensions

final class URL_DefaultApp_FaceTime: XCTestCase {
    func testInit() throws {
        let url = URL.faceTime(user: "1-408-555-5555")
        
        XCTAssertEqual(url.scheme, "facetime")
        XCTAssertEqual(url.absoluteString, "facetime://1-408-555-5555")
    }
    
    func testInitAudio() throws {
        let url = URL.faceTime(user: "1-408-555-5555", audio: true)
        
        XCTAssertEqual(url.scheme, "facetime-audio")
        XCTAssertEqual(url.absoluteString, "facetime-audio://1-408-555-5555")
    }
    
    func testURL() throws {
        let url = try XCTUnwrap(URL(string: "facetime:1-408-555-5555"))
        let app = try XCTUnwrap(url.app() as? URL.FaceTime)
        
        XCTAssertEqual(app.user, "1-408-555-5555")
    }
}
