//
//  EncryptionHandler.swift
//  
//
//  Created by Tom Rochat on 21/08/2020.
//

import Foundation
import CryptorRSA

final class EncryptionHandler {
    public func encrypt(filePath path: String, with keys: Keypair) throws {
        guard keys.publicKey != nil && keys.privateKey != nil else { throw KeyError.noKeys }

        let data = try getDataFromFile(at: path)
        let plainText = CryptorRSA.createPlaintext(with: data)

        guard let encryptedData = try plainText.encrypted(with: keys.publicKey!, algorithm: .sha256) else {
            throw EncryptionError.encryption
        }

        let newFileName = "\(path).\(Core.fileExtension)"
        guard let fileUrl = getFileUrl(from: newFileName) else { throw EncryptionError.write }
        do {
            try encryptedData.data.write(to: fileUrl)
            if Core.verbose {
                print("wrote encrypted data to \(newFileName)")
            }
        } catch {
            throw EncryptionError.write
        }
    }

    private func getDataFromFile(at path: String) throws -> Data {
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

    private func getFileUrl(from path: String) -> URL? {
        if !path.contains("/") {
            let fullPath = "\(FileManager.default.currentDirectoryPath)/\(path)"
            return URL(string: "file://\(fullPath)")
        }

        return URL(string: "file://\(path)")
    }
}
