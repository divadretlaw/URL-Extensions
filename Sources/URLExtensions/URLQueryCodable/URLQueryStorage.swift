//
//  URLQueryStorage.swift
//  URL+Extensions
//
//  Created by David Walter on 07.07.23.
//

import Foundation

struct URLQueryStorage: Sequence {
    private var stack: [String]
    private var container: [String: String]
    
    init(container: [String: String]) {
        self.container = container
        self.stack = []
    }
    
    subscript(key: String) -> String? {
        get {
            container[key]
        }
        set {
            container[key] = newValue
        }
    }
    
    var isEmpty: Bool {
        stack.isEmpty
    }
    
    mutating func push(_ value: String) {
        stack.append(value)
    }
    
    mutating func pop() -> String {
        stack.removeLast()
    }
    
    // MARK: - Dictionary
    
    var keys: Dictionary<String, String>.Keys {
        container.keys
    }
    
    var values: Dictionary<String, String>.Values {
        container.values
    }
    
    // MARK: - Sequence
    
    func makeIterator() -> Dictionary<String, String>.Iterator {
        container.makeIterator()
    }
}
