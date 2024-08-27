// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "OpenGraphKit",
    platforms: [.macOS(.v13)],
    products: [
        .executable(
            name: "opengraphkit",
            targets: ["OpenGraphKit"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            from: "1.2.0"
        ),
    ],
    targets: [
        .executableTarget(
            name: "OpenGraphKit",
            dependencies: [
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                ),
            ],
            path: ".",
            sources: [ "Sources/" ],
            resources: [
                .process("Resources/Fonts"),
                .process("Resources/Images")
            ]
        ),
    ]
)
