// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "GBLPing",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "GBLPing",
            targets: ["GBLPing"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "GBLPingLib",
            dependencies: [],
            path: "Sources",
            sources: ["include/SimplePing", "include/MacFinder"],
            cSettings: [
                .headerSearchPath("Sources/include")
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
        )
    ]
)
