// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Counters",
    products: [
        .library(name: "CounterCore", targets: ["CounterCore"]),
        .library(name: "CounterAPI", targets: ["CounterAPI"]),
        .library(name: "CounterStore", targets: ["CounterStore"]),
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
            dependencies: ["CounterAPI"]
        ),
        .target(
            name: "CounterStore",
            dependencies: ["CounterCore"]
        ),
        .testTarget(
            name: "CounterStoreTests",
            dependencies: ["CounterStore"]
        ),
        .target(name: "HTTPClient"),
        .target(
            name: "URLSessionHTTPClient",
            dependencies: ["HTTPClient"]
        ),
        .testTarget(
            name: "URLSessionHTTPClientTests",
            dependencies: ["URLSessionHTTPClient"]
        ),
    ]
)
