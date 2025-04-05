import Foundation
import Testing
@testable import URLExtensions

extension DefaultAppTests {
    struct SMS {
        @Test func `init`() throws {
            let url = URL.sms(number: "1-408-555-5555")

            #expect(url.scheme == "sms")
            #expect(url.absoluteString == "sms:1-408-555-5555")
        }

        @Test func url() throws {
            let url = try #require(URL(string: "sms:1-408-555-5555"))
            let app = try #require(url.app() as? URL.SMS)

            #expect(app.number == "1-408-555-5555")
        }

        @Test func emtpyURL() throws {
            let url = try #require(URL(string: "sms:"))
            let app = try #require(url.app() as? URL.SMS)

            #expect(app.number == "")
        }
    }
}
