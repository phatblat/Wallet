// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
// https://github.com/apple/swift-package-manager/blob/master/Documentation/PackageDescription.md

import PackageDescription

let package = Package(
    name: "Wallet",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .executable(
            name: "wallet",
            targets: ["wallet"]),
        .library(
            name: "WalletKit",
            targets: ["WalletKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMajor(from: "0.0.6")),
        .package(url: "https://github.com/apple/swift-crypto", .upToNextMajor(from: "1.0.1")),
        .package(url: "https://github.com/Quick/Quick", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/Quick/Nimble", .upToNextMajor(from: "9.0.0")),
    ],
    targets: [
        .target(
            name: "wallet",
            dependencies: ["WalletKit"]),
        .target(
            name: "WalletKit",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Crypto", package: "swift-crypto")
            ]),
        .testTarget(
            name: "WalletKitTests",
            dependencies: ["WalletKit", "Quick", "Nimble"]),
    ],
    swiftLanguageVersions: [.v5]
)
