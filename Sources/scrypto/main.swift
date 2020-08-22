import Foundation
import ArgumentParser

struct Scrypto: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "scrypto",
        abstract: "a small tool to play with rsa",
        version: "0.0.1",
        subcommands: [
            Encrypt.self,
            Decrypt.self,
        ]
    )
}

// MARK: - Encryption
struct Encrypt: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "encrypt",
        abstract: "Encrypt the given file"
    )

    @Argument(help: "The file to encode")
    private var file: String

    @Argument(help: "Path to your public key (PEM encoded file)")
    private var publicKeyPath: String

    @Argument(help: "Path to your private key (PEM encoded file)")
    private var privateKeyPath: String

    @Flag(help: "Run in verbose mode")
    private var verbose = false

    public func run() throws {
        Core.verbose = verbose

        var keys = Keypair(publicKeyPath: publicKeyPath, privateKeyPath: privateKeyPath)

        try keys.validateFiles()
        try keys.getKeys()

        let handler = EncryptionHandler()
        try handler.encrypt(filePath: file, with: keys)
    }
}

struct Decrypt: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "decrypt",
        abstract: "Decrypt the given tmlp file"
    )

    @Argument(help: "The file to encode")
    private var file: String

    @Argument(help: "Path to your public key (PEM encoded file)")
    private var publicKeyPath: String

    @Argument(help: "Path to your private key (PEM encoded file)")
    private var privateKeyPath: String

    @Flag(help: "Run in verbose mode")
    private var verbose = false

    public func run() throws {
        Core.verbose = verbose

        var keys = Keypair(publicKeyPath: publicKeyPath, privateKeyPath: privateKeyPath)

        try keys.validateFiles()
        try keys.getKeys()

        let handler = DecryptionHandler()
        try handler.decrypt(filePath: file, with: keys)
    }
}

Scrypto.main()
