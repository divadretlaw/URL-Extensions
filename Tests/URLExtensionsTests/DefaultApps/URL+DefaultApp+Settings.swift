import XCTest
@testable import URLExtensions

final class URL_DefaultApp_Settings: XCTestCase {
    func testInit() throws {
        let url = try XCTUnwrap(URL(string: "app-prefs:root=General&path=About"))
        let app = try XCTUnwrap(url.app() as? URL.Settings)
        
        XCTAssertEqual(app.parameter.root, .general)
        XCTAssertEqual(app.parameter.path, "About")
    }
}
