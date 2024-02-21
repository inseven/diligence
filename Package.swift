// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Diligence",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Diligence",
            targets: ["Diligence"]),
    ],
    dependencies: [
        .package(url: "https://github.com/inseven/licensable", from: "0.0.3"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
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
