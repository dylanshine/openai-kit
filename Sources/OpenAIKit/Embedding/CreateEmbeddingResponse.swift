import Foundation

public struct CreateEmbeddingResponse {
    public let object: String
    public let data: [Embedding]
    public let model: String
    public let usage: Usage
}

extension CreateEmbeddingResponse: Decodable {}
