// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "FinniversKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "FinniversKit",
            targets: ["FinniversKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/warp-ds/warp-ios.git", "0.0.1"..."999.0.0")
    ],
    targets: [
        .target(
            name: "FinniversKit",
            dependencies: [
                .product(name: "Warp", package: "warp-ios"),
            ],
            path: "FinniversKit/Sources",
            resources: [
                .process("Assets/Fonts"),
                .process("Assets/Sounds"),
            ]
        ),
    ]
)
