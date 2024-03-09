//
//  Logger.swift
//  URL+Extensions
//
//  Created by David Walter on 19.10.23.
//

import Foundation
import OSLog

extension Logger {
    #if swift(>=5.10)
    nonisolated(unsafe) static let url = Logger(subsystem: "at.davidwalter.extensions.url", category: "URL")
    #else
    static let url = Logger(subsystem: "at.davidwalter.extensions.url", category: "URL")
    #endif
}
