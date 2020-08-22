//
//  KeyError.swift
//  
//
//  Created by Tom Rochat on 21/08/2020.
//

import Foundation

enum KeyError: LocalizedError {
    case notFound(type: KeyType)
    case unreadable(type: KeyType)
    case invalidKey(type: KeyType)

    case noKeys

    var errorDescription: String? {
        switch self {
        case .notFound(let type):
            return "Could not find a key at the given path (\(type) key)"
        case .unreadable(let type):
            return "Cannot read the content of the given file; do I have enough permissions ? (\(type) key)"
        case .invalidKey(let type):
            return "The \(type) key does not seems to be valid"
        case .noKeys:
            return "Keys are not valid"
        }
    }
}
