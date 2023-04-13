import AsyncHTTPClient
import NIOHTTP1
import Foundation

struct CreateChatRequest: Request {
    let method: HTTPMethod = .POST
    let path = "/v1/chat/completions"
    let body: Data?
    
    init(
        model: String,
        messages: [Chat.Message],
        temperature: Double,
        topP: Double,
        n: Int,
        stream: Bool,
        stops: [String],
        maxTokens: Int?,
        presencePenalty: Double,
        frequencyPenalty: Double,
        logitBias: [String: Int],
        user: String?
    ) throws {
        
        let body = Body(
            model: model,
            messages: messages,
            temperature: temperature,
            topP: topP,
            n: n,
            stream: stream,
            stops: stops,
            maxTokens: maxTokens,
            presencePenalty: presencePenalty,
            frequencyPenalty: frequencyPenalty,
            logitBias: logitBias,
            user: user
        )
                
        self.body = try Self.encoder.encode(body)
    }
}

extension CreateChatRequest {
    struct Body: Encodable {
        let model: String
        let messages: [Chat.Message]
        let temperature: Double
        let topP: Double
        let n: Int
        let stream: Bool
        let stops: [String]
        let maxTokens: Int?
        let presencePenalty: Double
        let frequencyPenalty: Double
        let logitBias: [String: Int]
        let user: String?
            
        enum CodingKeys: CodingKey {
            case model
            case messages
            case temperature
            case topP
            case n
            case stream
            case stop
            case maxTokens
            case presencePenalty
            case frequencyPenalty
            case logitBias
            case user
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(model, forKey: .model)
            
            if !messages.isEmpty {
                try container.encode(messages, forKey: .messages)
            }

            try container.encode(temperature, forKey: .temperature)
            try container.encode(topP, forKey: .topP)
            try container.encode(n, forKey: .n)
            try container.encode(stream, forKey: .stream)
            
            if !stops.isEmpty {
                try container.encode(stops, forKey: .stop)
            }
            
            if let maxTokens {
                try container.encode(maxTokens, forKey: .maxTokens)
            }
            
            try container.encode(presencePenalty, forKey: .presencePenalty)
            try container.encode(frequencyPenalty, forKey: .frequencyPenalty)
            
            if !logitBias.isEmpty {
                try container.encode(logitBias, forKey: .logitBias)
            }
            
            try container.encodeIfPresent(user, forKey: .user)
        }
    }
}
