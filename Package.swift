// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "OpenGraphKit",
    platforms: [.macOS(.v13)],
    products: [
        .executable(
            name: "opengraphscript",
            targets: ["OpenGraphKit-Executable"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            from: "1.2.0"
        ),
    ],
    targets: [
        .target(
            name: "OpenGraphKit",
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals")
            ]
        ),
        .executableTarget(
            name: "OpenGraphKit-Executable",
            dependencies: [
                .target(name: "OpenGraphKit"),
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                ),
            ],
            path: ".",
            sources: [ "Sources/OpenGraphKit-Executable/" ],
            resources: [
                .process("Resources/Fonts"),
                .process("Resources/Images")
            ]
        ),
        .testTarget(
            name: "OpenGraphKitTests",
            dependencies: [
                .target(name: "OpenGraphKit")
            ]
        )
    ]
)
