import Foundation
import Testing
@testable import URLExtensions

struct AppLinkRepositoryTests {
    @Test func `init`() throws {
        let repository = AppLinkRepository()
        #expect(repository.types.isEmpty == true)
    }
    
    @Test func register() throws {
        let repository = AppLinkRepository()
        repository.register(type: URL.AppStore.self)
        #expect(repository.types.isEmpty == false)
    }
    
    @Test func unregister() throws {
        let repository = AppLinkRepository()
        repository.restoreDefaults()
        #expect(repository.types.isEmpty == false)
        repository.unregisterAll()
        #expect(repository.types.isEmpty == true)
    }
    
    @Test func urlWithAppNotRegistered() throws {
        let url = try #require(URL(string: "https://apps.apple.com/us/app/apple-store/id375380948?mt=8"))
        let repository = AppLinkRepository()
        #expect(url.app(from: repository) == nil)
    }
    
    @Test func urlWithAppRegistered() throws {
        let url = try #require(URL(string: "https://apps.apple.com/us/app/apple-store/id375380948?mt=8"))
        let repository = AppLinkRepository()
        repository.register(type: URL.AppStore.self)
        #expect(url.app(from: repository) != nil)
    }
}
