import Foundation
import Testing
@testable import URLExtensions

struct URLTests {
    @Test func noSchemeUrl() throws {
        let url = try #require(URL(link: "apple.com"))

        #expect(url.supportsSafari == true)
    }
    
    @Test func httpUrl() throws {
        let url = try #require(URL(string: "http://captive.apple.com"))

        #expect(url.supportsSafari == true)
    }
    
    @Test func httpsUrl() throws {
        let url = try #require(URL(string: "https://www.apple.com"))

        #expect(url.supportsSafari == true)
    }
    
    @Test func ftpUrl() throws {
        let url = try #require(URL(string: "ftp://localhost"))

        #expect(url.supportsSafari == false)
    }
    
    @Test func validAppleMapsUrl() throws {
        let url = try #require(URL(string: "https://maps.apple.com/?address=Cupertino"))

        #expect(url.supportsSafari == false)
    }
    
    @Test  func appleMapsWebsiteUrl() throws {
        let url = try #require(URL(string: "https://maps.apple.com/"))

        #expect(url.supportsSafari == true)
    }
}
