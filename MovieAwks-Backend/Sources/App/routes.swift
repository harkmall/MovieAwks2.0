import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    let unprotectedAPI = app.grouped("api")
    try unprotectedAPI.grouped("auth", "siwa").register(collection: SIWAController())

    let tokenProtectedAPI = unprotectedAPI.grouped(Token.authenticator())
    try tokenProtectedAPI.grouped("users").register(collection: UserController())
}
