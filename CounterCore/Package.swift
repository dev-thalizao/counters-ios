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
        .library(name: "CounterTests", targets: ["CounterTests"]),
        .library(name: "HTTPClient", targets: ["HTTPClient"]),
        .library(name: "URLSessionHTTPClient", targets: ["URLSessionHTTPClient"]),
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
        .target(name: "CounterTests"),
        .target(name: "HTTPClient"),
        .target(
            name: "URLSessionHTTPClient",
            dependencies: ["HTTPClient"]
        ),
        .testTarget(
            name: "URLSessionHTTPClientTests",
            dependencies: ["URLSessionHTTPClient", "CounterTests"]
        ),
    ]
)
