import AsyncHTTPClient
import NIOHTTP1
import Foundation

struct CreateChatRequest: Request {
    let method: HTTPMethod = .POST
    let path = "/v1/chat/completions"
    let body: HTTPClient.Body?
    
    init(
        model: String,
        messages: [Chat.Message],
        temperature: Double? = nil,
        topP: Double? = nil,
        n: Int? = nil,
        stream: Bool? = nil,
        stop: [String]? = nil,
        maxTokens: Int? = nil,
        presencePenalty: Double? = nil,
        frequencyPenalty: Double? = nil,
        logitBias: [String: Int]? = nil,
        user: String? = nil
    ) throws {
        
        let body = Body(
            model: model,
            messages: messages,
            temperature: temperature,
            topP: topP,
            n: n,
            stream: stream,
            stop: stop,
            maxTokens: maxTokens,
            presencePenalty: presencePenalty,
            frequencyPenalty: frequencyPenalty,
            logitBias: logitBias,
            user: user
        )
                
        self.body = .data(try Self.encoder.encode(body))
    }
}

extension CreateChatRequest {
    struct Body: Encodable {
        let model: String
        let messages: [Chat.Message]
        let temperature: Double?
        let topP: Double?
        let n: Int?
        let stream: Bool?
        let stop: [String]?
        let maxTokens: Int?
        let presencePenalty: Double?
        let frequencyPenalty: Double?
        let logitBias: [String: Int]?
        let user: String?
           
        private enum CodingKeys: String, CodingKey {
            case model
            case messages
            case temperature
            case topP = "top_p"
            case n
            case stream
            case stop
            case maxTokens = "max_tokens"
            case presencePenalty = "presence_penalty"
            case frequencyPenalty = "frequency_penalty"
            case logitBias = "logit_bias"
            case user
        }
    }
}
