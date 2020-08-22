//
//  DecryptionHandler.swift
//  
//
//  Created by Tom Rochat on 21/08/2020.
//

import Foundation
import CryptorRSA

final class DecryptionHandler {
    public func decrypt(filePath path: String, with keys: Keypair) throws {
        guard keys.publicKey != nil && keys.privateKey != nil else { throw KeyError.noKeys }

        let data = try Files.getDataFromFile(at: path)
        let encryptedData = CryptorRSA.EncryptedData(with: data)

        guard let decryptedData = try encryptedData.decrypted(with: keys.privateKey!, algorithm: .sha256) else {
            throw DecryptionError.invalidData
        }

        let newFileName = path.replacingOccurrences(of: ".\(Core.fileExtension)", with: "")
        guard let fileUrl = Files.getFileUrl(from: newFileName) else { throw DecryptionError.write }
        do {
            try decryptedData.data.write(to: fileUrl, options: .withoutOverwriting)
            if Core.verbose {
                print("wrote decrypted data to \(newFileName)")
            }
        } catch {
            #if DEBUG
            print(error)
            #endif
            throw DecryptionError.write
        }
    }
}
