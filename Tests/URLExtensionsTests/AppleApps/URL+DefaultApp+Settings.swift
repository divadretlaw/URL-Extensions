import Foundation
import Testing
@testable import URLExtensions

struct URL_DefaultApp_Settings {
    @Test func `init`() throws {
        let url = try #require(URL(string: "app-prefs:root=General&path=About"))
        let app = try #require(url.app() as? URL.Settings)
        
        #expect(app.parameter.root == .general)
        #expect(app.parameter.path == "About")
    }
}
