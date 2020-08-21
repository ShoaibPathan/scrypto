import Foundation
import ArgumentParser

struct Scrypto: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "scrypto",
        abstract: "a small tool to play with rsa",
        version: "0.0.1",
        subcommands: []
    )
}

Scrypto.main()
