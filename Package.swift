// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Diligence",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "Diligence",
            targets: ["Diligence"]),
    ],
    dependencies: [
        .package(url: "https://github.com/inseven/licensable", from: "0.0.8"),
    ],
    targets: [
        .target(
            name: "Diligence",
            dependencies: [
                .product(name: "Licensable", package: "licensable"),
            ],
            resources: [.process("Resources")]),
        .testTarget(
            name: "DiligenceTests",
            dependencies: ["Diligence"]),
    ]
)
