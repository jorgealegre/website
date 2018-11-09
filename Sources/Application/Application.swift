import Foundation
import Kitura
import LoggerAPI
import Configuration
import CloudEnvironment
import KituraContracts
import Health
import KituraStencil
import Stencil
import KituraWebSocket

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()

public class App {
    let router = Router()
    let cloudEnv = CloudEnv()

    public init() throws {
        router.setDefault(templateEngine: StencilTemplateEngine())
        router.get("/") { request, response, next in
            try response.render("index", context: [:]).end()
            next()
        }

        router.get("/game") { request, response, next in
            try response.render("game", context: [:]).end()
            next()
        }

        WebSocket.register(service: GameService(), onPath: "/game")
    }

    func postInit() throws {
        // Capabilities
        initializeMetrics(app: self)

        // Endpoints
        initializeHealthRoutes(app: self)
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: cloudEnv.port, with: router)
        Kitura.run()
    }
}
