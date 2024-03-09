//
//  Collection+Extensions.swift
//  URL+Extensions
//
//  Created by David Walter on 07.07.23.
//

import Foundation

extension Collection {
    subscript (safe index: Index?) -> Element? {
        guard let index = index else { return nil }
        return indices.contains(index) ? self[index] : nil
    }
}
