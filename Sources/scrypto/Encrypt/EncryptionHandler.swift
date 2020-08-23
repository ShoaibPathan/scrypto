//
//  EncryptionHandler.swift
//  
//
//  Created by Tom Rochat on 21/08/2020.
//

import Foundation
import CryptorRSA

struct EncryptionHandler {
    public static func encrypt(filePath path: String, with keys: Keypair, renamed: Bool) throws {
        guard keys.publicKey != nil && keys.privateKey != nil else { throw KeyError.noKeys }

        let data = try Files.getDataFromFile(at: path)
        let plainText = CryptorRSA.createPlaintext(with: data)

        guard let encryptedData = try plainText.encrypted(with: keys.publicKey!, algorithm: .sha256) else {
            throw EncryptionError.encryption
        }

        let encryptedFile = Files.getEncryptedFileName(for: path, renamed: renamed)
        guard let fileUrl = Files.getFileUrl(from: encryptedFile) else { throw EncryptionError.write }

        do {
            try encryptedData.data.write(to: fileUrl)
            if Core.verbose { print("wrote encrypted data to \(encryptedFile)") }
        } catch { throw EncryptionError.write }
    }
}
