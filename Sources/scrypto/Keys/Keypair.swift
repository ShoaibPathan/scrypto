//
//  Keypair.swift
//  
//
//  Created by Tom Rochat on 21/08/2020.
//

import Foundation
import CryptorRSA

struct Keypair {
    public let publicKeyPath: String
    public var publicKey: CryptorRSA.PublicKey?

    public let privateKeyPath: String
    public var privateKey: CryptorRSA.PrivateKey?

    init(publicKeyPath: String, privateKeyPath: String) {
        self.publicKeyPath = publicKeyPath
        self.privateKeyPath = privateKeyPath
    }

    // MARK: - Validation
    public func validateFiles() throws {
        guard FileManager.default.fileExists(atPath: publicKeyPath) else { throw KeyError.notFound(type: .publicKey) }
        guard FileManager.default.isReadableFile(atPath: publicKeyPath) else { throw KeyError.unreadable(type: .publicKey) }

        if Core.verbose {
            print("public key file is OK")
        }

        guard FileManager.default.fileExists(atPath: privateKeyPath) else { throw KeyError.notFound(type: .privateKey) }
        guard FileManager.default.isReadableFile(atPath: privateKeyPath) else { throw KeyError.unreadable(type: .privateKey) }

        if Core.verbose {
            print("private key file is OK")
        }

    }

    // MARK: - Get content of PEM files

    public mutating func getKeys() throws {
        try getPublicKey()
        try getPrivateKey()
    }

    private mutating func getPublicKey() throws {
        guard let pemFileData = FileManager.default.contents(atPath: publicKeyPath) else { throw KeyError.invalidKey(type: .publicKey) }

        do {
            publicKey = try CryptorRSA.createPublicKey(withPEM: pemFileData.base64EncodedString())
            if Core.verbose {
                print("public key is OK")
            }
        } catch {
            #if DEBUG
            print(error)
            #endif
            throw KeyError.invalidKey(type: .publicKey)
        }
    }

    private mutating func getPrivateKey() throws {
        guard let pemFileData = FileManager.default.contents(atPath: privateKeyPath) else { throw KeyError.invalidKey(type: .privateKey) }

        do {
            privateKey = try CryptorRSA.createPrivateKey(withPEM: pemFileData.base64EncodedString())
            if Core.verbose {
                print("private key is OK")
            }
        } catch {
            #if DEBUG
            print(error)
            #endif
            throw KeyError.invalidKey(type: .privateKey)
        }
    }
}
