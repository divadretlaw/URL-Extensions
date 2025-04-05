import Foundation
import Testing
@testable import URLExtensions

extension DefaultAppTests {
    struct FaceTime {
        @Test func `init`() throws {
            let url = URL.faceTime(user: "1-408-555-5555")

            #expect(url.scheme == "facetime")
            #expect(url.absoluteString == "facetime://1-408-555-5555")
        }

        @Test func initAudio() throws {
            let url = URL.faceTime(user: "1-408-555-5555", audio: true)

            #expect(url.scheme == "facetime-audio")
            #expect(url.absoluteString == "facetime-audio://1-408-555-5555")
        }

        @Test func url() throws {
            let url = try #require(URL(string: "facetime:1-408-555-5555"))
            let app = try #require(url.app() as? URL.FaceTime)

            #expect(app.user == "1-408-555-5555")
        }
    }
}
