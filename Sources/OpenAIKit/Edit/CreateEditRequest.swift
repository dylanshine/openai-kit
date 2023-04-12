import AsyncHTTPClient
import NIOHTTP1
import Foundation

struct CreateEditRequest: Request {
    let method: HTTPMethod = .POST
    let path = "/v1/edits"
    let body: Data?
    
    init(
        model: String,
        input: String,
        instruction: String,
        n: Int,
        temperature: Double,
        topP: Double
    ) throws {
        
        let body = Body(
            model: model,
            input: input,
            instruction: instruction,
            n: n,
            temperature: temperature,
            topP: topP
        )
                
        self.body = try Self.encoder.encode(body)
    }
}

extension CreateEditRequest {
    struct Body: Encodable {
        let model: String
        let input: String
        let instruction: String
        let n: Int
        let temperature: Double
        let topP: Double
    }
}
