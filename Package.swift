// swift-tools-version:5.9
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
    ],
    targets: [
        .target(
            name: "FinniversKit",
            path: "FinniversKit/Sources",
            resources: [
                .process("Assets/Fonts"),
                .process("Assets/Sounds"),
            ]
        ),
    ]
)
