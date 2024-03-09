import XCTest
@testable import URLExtensions

final class AppLinkRepositoryTests: XCTestCase {
    func testInit() throws {
        let repository = AppLinkRepository()
        XCTAssertTrue(repository.types.isEmpty)
    }
    
    func testRegister() throws {
        let repository = AppLinkRepository()
        repository.register(type: URL.AppStore.self)
        XCTAssertFalse(repository.types.isEmpty)
    }
    
    func testUnregister() throws {
        let repository = AppLinkRepository()
        repository.restoreDefaults()
        XCTAssertFalse(repository.types.isEmpty)
        repository.unregisterAll()
        XCTAssertTrue(repository.types.isEmpty)
    }
    
    func testURLWithAppNotRegistered() throws {
        let url = try XCTUnwrap(URL(string: "https://apps.apple.com/us/app/apple-store/id375380948?mt=8"))
        let repository = AppLinkRepository()
        XCTAssertNil(url.app(from: repository))
    }
    
    func testURLWithAppRegistered() throws {
        let url = try XCTUnwrap(URL(string: "https://apps.apple.com/us/app/apple-store/id375380948?mt=8"))
        let repository = AppLinkRepository()
        repository.register(type: URL.AppStore.self)
        XCTAssertNotNil(url.app(from: repository))
    }
}
