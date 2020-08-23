import Foundation
import ArgumentParser

struct Scrypto: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "scrypto",
        abstract: "a small tool to encrypt / decrypt files",
        version: "0.1",
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

    @Flag(name: .shortAndLong, help: "Replace the file's name with a uuid")
    private var rename = false

    @Flag(name: .shortAndLong, help: "Run in verbose mode")
    private var verbose = false

    public func run() throws {
        Core.verbose = verbose

        var keys = Keypair(publicKeyPath: publicKeyPath, privateKeyPath: privateKeyPath)
        try keys.validateFiles()
        try keys.getKeys()

        try EncryptionHandler.encrypt(filePath: file, with: keys, renamed: rename)
    }
}

struct Decrypt: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "decrypt",
        abstract: "Decrypt the given \(Core.fileExtension) file"
    )

    @Argument(help: "The file to decode")
    private var file: String

    @Argument(help: "Path to your public key (PEM encoded file)")
    private var publicKeyPath: String

    @Argument(help: "Path to your private key (PEM encoded file)")
    private var privateKeyPath: String

    @Flag(name: .shortAndLong, help: "Run in verbose mode")
    private var verbose = false

    public func run() throws {
        Core.verbose = verbose

        var keys = Keypair(publicKeyPath: publicKeyPath, privateKeyPath: privateKeyPath)
        try keys.validateFiles()
        try keys.getKeys()

        try Files.checkFileExtension(at: file)
        try DecryptionHandler.decrypt(filePath: file, with: keys)
    }
}

Scrypto.main()
