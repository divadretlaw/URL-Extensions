//
//  URL+Clock.swift
//  URL+Extensions
//
//  Created by David Walter on 10.07.23.
//

import Foundation

extension URL {
    /// Creates a Clock URL instance from the provided data.
    ///
    /// - Parameter clock: The selected tab of the clock app.
    public static func clock(tab: Clock.Tab) -> URL {
        // swiftlint:disable:next force_unwrapping
        return URL(string: "\(tab.scheme)://")!
    }
}

extension URL {
    // MARK: - App
    
    public struct Clock: Equatable, Hashable, Codable, AppLink {
        public let url: URL
        public let tab: Tab
        
        public init?(url: URL) {
            self.url = url
            
            switch url.scheme?.lowercased() {
            case Tab.alarm.scheme:
                self.tab = .alarm
            case Tab.sleepAlarm.scheme:
                self.tab = .sleepAlarm
            case Tab.stopwatch.scheme:
                self.tab = .stopwatch
            case Tab.timer.scheme:
                self.tab = .timer
            case Tab.worldclock.scheme:
                self.tab = .worldclock
            default:
                return nil
            }
        }
        
        public init(tab: Tab) {
            self.url = URL.clock(tab: tab)
            self.tab = tab
        }
        
        // MARK: App Link
        
        public static var isDefaultApp: Bool { true }
        
        public static var schemes: [String] {
            ["clock-alarm", "clock-sleep-alarm", "clock-stopwatch", "clock-timer", "clock-worldclock"]
        }
    }
}

// MARK: - Subtypes

extension URL.Clock {
    public enum Tab: Int, Codable, Sendable {
        case alarm
        case sleepAlarm
        case stopwatch
        case timer
        case worldclock
        
        var scheme: String {
            switch self {
            case .alarm:
                return "clock-alarm"
            case .sleepAlarm:
                return "clock-sleep-alarm"
            case .stopwatch:
                return "clock-stopwatch"
            case .timer:
                return "clock-timer"
            case .worldclock:
                return "clock-worldclock"
            }
        }
    }
}
