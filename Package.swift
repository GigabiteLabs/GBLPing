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
            name: "MacFinder",
            dependencies: [],
            path: "Sources",
            sources: ["MacFinder"],
            cSettings: [
                .headerSearchPath("Sources/MacFinder/Include")
            ]
        ),
        .target(
            name: "SimplePing",
            dependencies: [],
            path: "Sources",
            sources: [
                "SimplePing"
            ],
            cSettings: [
                .headerSearchPath("Sources")
            ]
        ),
        .target(
            name: "GBLPing",
            dependencies: [
                "MacFinder",
                "SimplePing"
            ],
            exclude: [
                "ObjC/"
            ],
            cSettings: [
                .headerSearchPath("ObjC/Include")
            ]
        ),
        .testTarget(
            name: "GBLPingTests",
            dependencies: ["GBLPing"]
        ),
    ]
)
