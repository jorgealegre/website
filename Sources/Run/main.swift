import App
import Vapor

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
//app.http.server.configuration.hostname = "0.0.0.0"
defer { app.shutdown() }
try configure(app)
try app.run()
