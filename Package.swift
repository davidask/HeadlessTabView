// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "HeadlessTabView",
    platforms: [
        .iOS(.v14),
        .tvOS(.v14),
    ],
    products: [
        .library(
            name: "HeadlessTabView",
            targets: ["HeadlessTabView"]
        )
    ],
    targets: [
        .target(
            name: "HeadlessTabView"
        )
    ]
)
