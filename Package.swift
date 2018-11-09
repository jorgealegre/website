// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "website",
    dependencies: [
      .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "2.5.0"),
      .package(url: "https://github.com/IBM-Swift/Kitura-WebSocket.git", from: "2.1.1"),
      .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", from: "1.7.1"),
      .package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git", from: "1.10.0"),
      .package(url: "https://github.com/IBM-Swift/CloudEnvironment.git", from: "7.1.0"),
      .package(url: "https://github.com/IBM-Swift/Configuration.git", from: "3.0.0"),
      .package(url: "https://github.com/RuntimeTools/SwiftMetrics.git", from: "2.0.0"),
      .package(url: "https://github.com/IBM-Swift/Health.git", from: "1.0.0"),
    ],
    targets: [
      .target(name: "website", dependencies: [.target(name: "Application"), "Kitura" , "HeliumLogger"]),
      .target(name: "Application", dependencies: ["Kitura", "Kitura-WebSocket", "Configuration", "CloudEnvironment", "SwiftMetrics", "Health", "KituraStencil"]),
      .testTarget(name: "ApplicationTests" , dependencies: [.target(name: "Application"), "Kitura", "HeliumLogger"])
    ]
)
