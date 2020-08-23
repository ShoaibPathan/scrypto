//
//  File.swift
//  
//
//  Created by Tom Rochat on 21/08/2020.
//

import Foundation

struct Files {
    enum FileError: LocalizedError {
        case notFound
        case unreadable
        case noData
        case wrongExtension

        case urlError

        var errorDescription: String? {
            switch self {
            case .notFound:
                return "The given path does not seems valid"
            case .unreadable:
                return "The file could not be read (permissions?)"
            case .noData:
                return "The file does not contains any data; or it could not be read"
            case .wrongExtension:
                return "The file extension is invalid"
            case .urlError:
                return "Could not get the file URL"
            }
        }
    }

    public static func getDataFromFile(at path: String) throws -> Data {
        guard FileManager.default.fileExists(atPath: path) else { throw FileError.notFound }
        guard FileManager.default.isReadableFile(atPath: path) else { throw FileError.unreadable }

        guard let content = FileManager.default.contents(atPath: path) else { throw FileError.noData }
        if Core.verbose { print("file is ok (\(content.count) bytes read)") }

        return content
    }

    public static func checkFileExtension(at path: String) throws {
        guard let range = path.range(of: ".", options: .backwards) else { throw FileError.wrongExtension }

        let fileExtension = path[range.upperBound...]
        guard fileExtension == Core.fileExtension else { throw FileError.wrongExtension }
    }

    public static func getFileUrl(from path: String) -> URL? {
        if !path.contains("/") {
            let fullPath = "\(FileManager.default.currentDirectoryPath)/\(path)"
            return URL(string: "file://\(fullPath)")
        }

        return URL(string: "file://\(path)")
    }

    // MARK: - File naming
    public static func getEncryptedFileName(for path: String) -> String {
        "\(path).\(Core.fileExtension)"
    }

    public static func getDecryptedFileName(for path: String) -> String {
        var newPath = path.replacingOccurrences(of: ".\(Core.fileExtension)", with: "")
        if FileManager.default.fileExists(atPath: newPath) {
            newPath.append("_\(UUID().uuidString.lowercased())")
        }

        return newPath
    }

}
