import Foundation
import Testing
@testable import URLExtensions

extension DefaultAppTests {
    struct Other {
        @Test func books() throws {
            let url = try #require(URL(string: "ibooks://"))

            #expect(url.app() is URL.Books)
        }

        @Test func calendar() throws {
            let url = try #require(URL(string: "calshow://"))

            #expect(url.app() is URL.Calendar)
        }

        @Test func calculator() throws {
            let url = try #require(URL(string: "calc://"))

            #expect(url.app() is URL.Calculator)
        }

        @Test func camera() throws {
            let url = try #require(URL(string: "camera://"))

            #expect(url.app() is URL.Camera)
        }

        @Test func contacts() throws {
            let url = try #require(URL(string: "contact://"))

            #expect(url.app() is URL.Contacts)
        }

        @Test func files() throws {
            let url = try #require(URL(string: "shareddocuments://"))

            #expect(url.app() is URL.Files)
        }

        @Test func freeform() throws {
            let url = try #require(URL(string: "freeform://"))

            #expect(url.app() is URL.Freeform)
        }

        @Test func notes() throws {
            let url = try #require(URL(string: "mobilenotes://"))

            #expect(url.app() is URL.Notes)
        }

        @Test func reminders() throws {
            let url = try #require(URL(string: "x-apple-reminder://"))

            #expect(url.app() is URL.Reminders)
        }

        @Test func stocks() throws {
            let url = try #require(URL(string: "stocks://"))

            #expect(url.app() is URL.Stocks)
        }
    }
}
