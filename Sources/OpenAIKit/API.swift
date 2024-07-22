import Foundation

public struct API {
    public let scheme: Scheme
    public let host: String
    public let path: String?
    
    public init(
        scheme: API.Scheme,
        host: String,
        pathPrefix path: String? = nil
    ) {
        self.scheme = scheme
        self.host = host
        self.path = path
    }
}

extension API {
    public enum Scheme {
        case http
        case https
        case custom(String)
        
        var value: String {
            switch self {
            case .http:
                return "http"
            case .https:
                return "https"
            case .custom(let scheme):
                return scheme
            }
        }
    }
}
