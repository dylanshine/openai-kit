import NIOHTTP1
import Foundation

struct RetrieveFileContentRequest: Request {
    let method: HTTPMethod = .GET
    let path: String
    
    init(id: String) {
        self.path = "/v1/files/\(id)/content"
    }
}

