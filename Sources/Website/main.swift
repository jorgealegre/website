import Foundation

import Kitura
import KituraWebSocket

import KituraStencil

import HeliumLogger

HeliumLogger.use()

let router = Router()

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
