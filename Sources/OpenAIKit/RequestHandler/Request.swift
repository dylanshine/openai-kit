import AsyncHTTPClient
import NIOHTTP1
import Foundation

protocol Request {
    var method: HTTPMethod { get }
    var scheme: API.Scheme { get }
    var host: String { get }
    var path: String { get }
    var body: Data? { get }
    var headers: HTTPHeaders { get }
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { get }
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
}

extension Request {
    static var encoder: JSONEncoder { .requestEncoder }

    var scheme: API.Scheme { .https }
    var host: String { "api.openai.com" }
    var body: Data? { nil }
    
    var headers: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "application/json")
        return headers
    }
    
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { .convertFromSnakeCase }
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { .secondsSince1970 }
}

extension JSONEncoder {
    static var requestEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
}
