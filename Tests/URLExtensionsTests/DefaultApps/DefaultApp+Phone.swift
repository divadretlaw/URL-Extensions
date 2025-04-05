import Foundation
import Testing
@testable import URLExtensions

extension DefaultAppTests {
    struct Phone {
        @Test func `init`() throws {
            let url = URL.phone(number: "1-408-555-5555")

            #expect(url.scheme == "tel")
            #expect(url.absoluteString == "tel:1-408-555-5555")
        }

        @Test func url() throws {
            let url = try #require(URL(string: "tel:1-408-555-5555"))
            let app = try #require(url.app() as? URL.Phone)

            #expect(app.number == "1-408-555-5555")
        }

        @Test func emtpyURL() throws {
            let url = try #require(URL(string: "tel:"))
            let app = try #require(url.app() as? URL.Phone)

            #expect(app.number == "")
        }
    }
}
