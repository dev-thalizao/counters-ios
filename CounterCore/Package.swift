// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Counters",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "CounterCore", targets: ["CounterCore"]),
        .library(name: "CounterAPI", targets: ["CounterAPI"]),
        .library(name: "CounterStore", targets: ["CounterStore"]),
        .library(name: "CounterPresentation", targets: ["CounterPresentation"]),
        .library(name: "CounterUI", targets: ["CounterUI"]),
        .library(name: "CounterTests", targets: ["CounterTests"])
    ],
    dependencies: [],
    targets: [
        .target(name: "CounterCore"),
        .testTarget(
            name: "CounterCoreTests",
            dependencies: ["CounterCore"]
        ),
        .target(
            name: "CounterAPI",
            dependencies: ["CounterCore"]
        ),
        .testTarget(
            name: "CounterAPITests",
            dependencies: ["CounterAPI", "CounterTests"]
        ),
        .target(
            name: "CounterStore",
            dependencies: ["CounterCore"]
        ),
        .testTarget(
            name: "CounterStoreTests",
            dependencies: ["CounterStore", "CounterTests"]
        ),
        .target(
            name: "CounterPresentation",
            dependencies: ["CounterCore"]
        ),
        .testTarget(
            name: "CounterPresentationTests",
            dependencies: ["CounterPresentation", "CounterTests"]
        ),
        .target(
            name: "CounterUI",
            dependencies: ["CounterPresentation"]
        ),
        .testTarget(
            name: "CounterUITests",
            dependencies: ["CounterUI", "CounterTests"]
        ),
        .target(name: "CounterTests")
    ]
)
