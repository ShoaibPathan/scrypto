//
//  File.swift
//  
//
//  Created by Tom Rochat on 21/08/2020.
//

import Foundation

struct Files {
    public static func getDataFromFile(at path: String) throws -> Data {
        guard FileManager.default.fileExists(atPath: path) else { throw EncryptionError.notFound }
        guard FileManager.default.isReadableFile(atPath: path) else { throw EncryptionError.unreadable }

        if Core.verbose {
            print("Reading file content...")
        }
        guard let content = FileManager.default.contents(atPath: path) else { throw EncryptionError.noData }
        if Core.verbose {
            print("File content OK")
        }

        return content
    }

    public static func getFileUrl(from path: String) -> URL? {
        if !path.contains("/") {
            let fullPath = "\(FileManager.default.currentDirectoryPath)/\(path)"
            return URL(string: "file://\(fullPath)")
        }

        return URL(string: "file://\(path)")
    }
}
