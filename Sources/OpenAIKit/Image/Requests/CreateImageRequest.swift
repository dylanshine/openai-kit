import AsyncHTTPClient
import NIOHTTP1
import Foundation

struct CreateImageRequest: Request {
    let method: HTTPMethod = .POST
    let path = "/v1/images/generations"
    let body: HTTPClient.Body?
    
    init(
        prompt: String,
        n: Int,
        size: Image.Size,
        user: String?
    ) throws {
        
        let body = Body(
            prompt: prompt,
            n: n,
            size: size,
            user: user
        )
                
        self.body = .data(try Self.encoder.encode(body))
    }
}

extension CreateImageRequest {
    struct Body: Encodable {
        let prompt: String
        let n: Int
        let size: Image.Size
        let user: String?
    }
}
