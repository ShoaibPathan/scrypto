//
//  EncryptionError.swift
//  
//
//  Created by Tom Rochat on 21/08/2020.
//

import Foundation

enum EncryptionError: LocalizedError {
    case notFound
    case noData
    case unreadable

    case encryption
    case write

    var errorDescription: String? {
        switch self {
        case .notFound:
            return "The specified file could not be found"
        case .noData:
            return "Nothing to encode"
        case .unreadable:
            return "Could not open the file to encode"
        case .encryption:
            return "Failed to encrypt the data"
        case .write:
            return "Failed to write encrypted data to file (permissions ?)"
        }
    }
}
