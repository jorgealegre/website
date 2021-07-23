//
// 
//

import Vapor

enum Constants {
    static let title = "Jorge Alegre"
}

func routes(_ app: Application) throws {
    app.get { req in
        return req.view.render("index", ["title": Constants.title])
    }
}
