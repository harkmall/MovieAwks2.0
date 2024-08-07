import Fluent
import Vapor

func routes(_ app: Application) throws {
    let unprotectedAPI = app.grouped("api")
    try unprotectedAPI.grouped("auth", "siwa").register(collection: SIWAController())
    
    let tokenProtectedAPI = unprotectedAPI.grouped(Token.authenticator()).grouped(User.guardMiddleware())
    try tokenProtectedAPI.grouped("users").register(collection: UserController())
    try tokenProtectedAPI.register(collection: TMDBController())
    try tokenProtectedAPI.register(collection: MovieRatingController())
}
