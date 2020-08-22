//
//  DecryptionError.swift
//  
//
//  Created by Tom Rochat on 21/08/2020.
//

import Foundation

enum DecryptionError: LocalizedError {
    case invalidData
    case write

    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "Could not decrypt data"
        case .write:
            return "Could not write decrypted data (permissions ?)"
        }
    }
}
