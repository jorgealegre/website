import Foundation

import Kitura
import KituraWebSocket

import KituraStencil

import HeliumLogger
import LoggerAPI

Log.logger = HeliumLogger()
HeliumLogger.use()

class SecurityHandler: RouterMiddleware {
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        if !_isDebugAssertConfiguration() {
            if request.headers["User-Agent"] ?? "" == "ELB-HealthChecker/1.0" {
                Log.info("ELB HealthCheck...")
            } else if request.headers["X-Forwarded-Proto"] ?? "" != "https" {
                Log.info("Non secure request, redirecting...")
                try response.redirect("https://georgealegre.com", status: .movedPermanently)
            }
            
            response.headers["Strict-Transport-Security"] = "max-age=31536000" // 1 year
        }
        next()
    }
}

extension Router {
    convenience init(forcingHTTPS: Bool) {
        self.init()
        self.all(middleware: SecurityHandler())
    }
}

let router = Router(forcingHTTPS: true)
    
router.setDefault(templateEngine: StencilTemplateEngine())

router.all("/static", middleware: StaticFileServer())

router.get("/") { request, response, next in
    defer {
        next()
    }
    
    try response.render("index", context: [:]).end()
}

router.get("/game") { request, response, next in
    defer {
        next()
    }
    
    try response.render("game", context: [:]).end()
}

WebSocket.register(service: GameService(), onPath: "/game")

Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
