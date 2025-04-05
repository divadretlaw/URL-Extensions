import Foundation
import Testing
@testable import URLExtensions

extension DefaultAppTests {
    struct AppStore {
        @Test func initDefault() throws {
            let parameters = URL.AppStoreParameter(id: 375380948)
            let url = URL.appStore(parameters: parameters)
            
            #expect(url.scheme == "itms-apps")
            #expect(url.absoluteString == "itms-apps://apps.apple.com/app/id375380948")
        }
        
        @Test func `init`() throws {
            let parameters = URL.AppStoreParameter(id: 375380948)
            let url = URL.appStore(parameters: parameters, preferUniversalLink: true)
            
            #expect(url.scheme == "https")
            #expect(url.absoluteString == "https://apps.apple.com/app/id375380948")
        }
        
        @Test func initCountryCode() throws {
            let parameters = URL.AppStoreParameter(id: 375380948, countryCode: "at")
            let url = URL.appStore(parameters: parameters, preferUniversalLink: true)
            
            #expect(url.scheme == "https")
            #expect(url.absoluteString == "https://apps.apple.com/at/app/id375380948")
        }
        
        @Test func iTunes() throws {
            let url = try #require(URL(string: "https://itunes.apple.com/us/app/apple-store/id375380948?mt=8"))
            let app = try #require(url.app() as? URL.AppStore)
            
            #expect(app.parameters.id == 375380948)
        }
        
        @Test func apps() throws {
            let url = try #require(URL(string: "https://apps.apple.com/us/app/apple-store/id375380948?mt=8"))
            let app = try #require(url.app() as? URL.AppStore)
            
            #expect(app.parameters.id == 375380948)
        }
        
        @Test func withoutRegion() throws {
            let url = try #require(URL(string: "https://itunes.apple.com/app/apple-store/id375380948?mt=8"))
            let app = try #require(url.app() as? URL.AppStore)
            
            #expect(app.parameters.id == 375380948)
        }
    }
}
