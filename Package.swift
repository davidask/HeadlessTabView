// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "HeadlessTabView",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
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
