//
//  AppLinkRepository.swift
//  URL+Extensions
//
//  Created by David Walter on 09.03.24.
//

import Foundation

public final class AppLinkRepository: @unchecked Sendable {
    public static let shared = AppLinkRepository.default()
    
    private(set) var _types: [AppLink.Type]
    private let lock: NSLocking
    
    init() {
        self._types = []
        self.lock = NSLock()
    }
    
    init(types: [AppLink.Type]) {
        self._types = types
        self.lock = NSLock()
    }
    
    var types: [AppLink.Type] {
        lock.withLock {
            _types
        }
    }
    
    var allUniversalLinkTypes: [AppLink.Type] {
        types.filter { $0.canBeUniversalLink }
    }
    
    /// Register the given ``AppLink`` type
    ///
    /// - Parameter type: The type to register
    public func register(type: AppLink.Type) {
        lock.withLock {
            _types.append(type)
        }
    }
    
    /// Register the given ``AppLink`` types
    ///
    /// - Parameter types: The types to register
    public func register(types newTypes: [AppLink.Type]) {
        lock.withLock {
            _types.append(contentsOf: newTypes)
        }
    }
    
    /// Unregister all currently registered ``AppLink`` types
    public func unregisterAll() {
        lock.withLock {
            _types = []
        }
    }
    
    /// Restores the default ``AppLink`` types
    public func restoreDefaults() {
        let defaults = AppLinkRepository.default()
        lock.withLock {
            _types = defaults.types
        }
    }
    
    static func `default`() -> AppLinkRepository {
        let appleTypes: [AppLink.Type] = [
            URL.AppleMaps.self,
            URL.AppStore.self,
            URL.Books.self,
            URL.Browser.self,
            URL.Calculator.self,
            URL.Calendar.self,
            URL.Camera.self,
            URL.Clips.self,
            URL.Clock.self,
            URL.Contacts.self,
            URL.FaceTime.self,
            URL.Files.self,
            URL.Freeform.self,
            URL.Health.self,
            URL.iTunes.self,
            URL.Mail.self,
            URL.Music.self,
            URL.MusicClassical.self,
            URL.News.self,
            URL.Notes.self,
            URL.Phone.self,
            URL.Photos.self,
            URL.Reminders.self,
            URL.Safari.self,
            URL.Settings.self,
            URL.Shortcuts.self,
            URL.SMS.self,
            URL.Stocks.self,
            URL.TestFlight.self,
            URL.TV.self,
            URL.Wallet.self
        ]
        
        let thirdPartyTypes: [AppLink.Type] = [
            URL.DuckDuckGoPrivacyBrowser.self,
            URL.Firefox.self,
            URL.GitHub.self,
            URL.GoogleMaps.self,
            URL.VLC.self,
            URL.WhatsApp.self,
            URL.YouTube.self
        ]
        
        return AppLinkRepository(types: appleTypes + thirdPartyTypes)
    }
}
