import Foundation

public struct APIError: Error, Decodable {
    public let message: String
    public let type: String
    public let param: String?
    public let code: Int?
}

public struct APIErrorResponse: Error, Decodable {
    public let error: APIError
}


