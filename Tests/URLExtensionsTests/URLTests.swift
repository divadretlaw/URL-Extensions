import XCTest
@testable import URLExtensions

final class URLTests: XCTestCase {
    func testUrlAppPerformanceHttps() throws {
        let testData = (0..<10_000).map { _ in URL(string: "https://www.\(UUID().uuidString).com")! }
        
        measure {
            for url in testData {
                let app = url.app()
                XCTAssertNil(app)
            }
        }
    }
    
    func testUrlAppPerformanceCustom() throws {
        let testData = (0..<100_00).map { _ in URL(string: "custom-app-scheme://www.\(UUID().uuidString).com")! }
        
        measure {
            for url in testData {
                let app = url.app()
                XCTAssertNil(app)
            }
        }
    }
    
    func testNoSchemeUrl() throws {
        let url = try XCTUnwrap(URL(link: "apple.com"))
        
        XCTAssertTrue(url.supportsSafari)
    }
    
    func testHttpUrl() throws {
        let url = try XCTUnwrap(URL(string: "http://captive.apple.com"))
        
        XCTAssertTrue(url.supportsSafari)
    }
    
    func testHttpsUrl() throws {
        let url = try XCTUnwrap(URL(string: "https://www.apple.com"))
        
        XCTAssertTrue(url.supportsSafari)
    }
    
    func testFtpUrl() throws {
        let url = try XCTUnwrap(URL(string: "ftp://localhost"))
        
        XCTAssertFalse(url.supportsSafari)
    }
    
    func testValidAppleMapsUrl() throws {
        let url = try XCTUnwrap(URL(string: "https://maps.apple.com/?address=Cupertino"))
        
        XCTAssertFalse(url.supportsSafari)
    }
    
    func testAppleMapsWebsiteUrl() throws {
        let url = try XCTUnwrap(URL(string: "https://maps.apple.com/"))
        
        XCTAssertTrue(url.supportsSafari)
    }
}
