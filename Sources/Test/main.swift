import Foundation

import Kitura
import KituraWebSocket

import KituraMustache

import HeliumLogger

HeliumLogger.use()

let router = Router()

router.setDefault(templateEngine: MustacheTemplateEngine())

router.all("/static", middleware: StaticFileServer())

router.get("/game") { request, response, next in
    defer {
        next()
    }
    
    var context: [String: Any] = [
        "name": "Arthur",
        "date": Date(),
        "realDate": Date().addingTimeInterval(60*60*24*3),
        "late": true
    ]
    
    // Let template format dates with ``
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    context["format"] = dateFormatter
    
    try response.render("test", context: context).end()
}

WebSocket.register(service: GameService(), onPath: "/game")

Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
