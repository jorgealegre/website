// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "kitura_test",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1),
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 1),
        .Package(url: "https://github.com/IBM-Swift/Kitura-WebSocket", majorVersion: 0, minor: 9),
        .Package(url: "https://github.com/IBM-Swift/Kitura-MustacheTemplateEngine.git", majorVersion: 1)
    ]
)
