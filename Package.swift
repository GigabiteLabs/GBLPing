// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "GBLPing",
    platforms: [
        .macOS(.v10_15), .iOS(.v11),
    ],
    products: [
        .library(
            name: "GBLPing",
            targets: ["GBLPing"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "GBLPingLib",
            dependencies: [],
            path: "Sources",
            sources: ["SimplePing", "MacFinder"],
            cSettings: [
                .headerSearchPath("Sources")
            ]
        ),
        .target(
            name: "GBLPing",
            dependencies: [
                "GBLPingLib"
            ]
        ),
        .testTarget(
            name: "GBLPingTests",
            dependencies: ["GBLPing"]
        ),
    ]
)
