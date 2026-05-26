// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "DragoDateTimePicker",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "DragoDateTimePicker",
            targets: ["DragoDateTimePicker"]
        )
    ],
    targets: [
        .target(
            name: "DragoDateTimePicker",
            path: "Sources/DragoDateTimePicker"
        )
    ]
)
