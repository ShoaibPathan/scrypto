// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "scrypto",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.0"),
        .package(name: "CryptorRSA", url: "https://github.com/IBM-Swift/BlueRSA", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "scrypto",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "CryptorRSA", package: "CryptorRSA")
            ]),
        .testTarget(
            name: "scryptoTests",
            dependencies: ["scrypto"]),
    ]
)
