//
//  DecryptionHandler.swift
//  
//
//  Created by Tom Rochat on 21/08/2020.
//

import Foundation
import CryptorRSA

struct DecryptionHandler {
    public static func decrypt(filePath path: String, with keys: Keypair) throws {
        guard keys.publicKey != nil && keys.privateKey != nil else { throw KeyError.noKeys }

        let data = try Files.getDataFromFile(at: path)
        let encryptedData = CryptorRSA.EncryptedData(with: data)

        guard let decryptedData = try encryptedData.decrypted(with: keys.privateKey!, algorithm: .sha256) else {
            throw DecryptionError.invalidData
        }

        let decryptedFile = Files.getDecryptedFileName(for: path)
        guard let fileUrl = Files.getFileUrl(from: decryptedFile) else { throw DecryptionError.write }

        do {
            try decryptedData.data.write(to: fileUrl)
            if Core.verbose { print("wrote decrypted data to \(decryptedFile)") }
        } catch {
            throw DecryptionError.write
        }
    }
}
