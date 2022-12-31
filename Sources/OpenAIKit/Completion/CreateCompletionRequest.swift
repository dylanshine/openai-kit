import AsyncHTTPClient
import NIOHTTP1
import Foundation

struct CreateCompletionRequest: Request {
    let method: HTTPMethod = .POST
    let path = "/v1/completions"
    let body: HTTPClient.Body?
    
    init(
        model: String,
        prompts: [String],
        suffix: String?,
        maxTokens: Int,
        temperature: Double,
        topP: Double,
        n: Int,
        stream: Bool,
        logprobs: Int?,
        echo: Bool,
        stops: [String],
        presencePenalty: Double,
        frequencyPenalty: Double,
        bestOf: Int,
        logitBias: [String: Int],
        user: String?
    ) throws {
        
        let body = Body(
            model: model,
            prompts: prompts,
            suffix: suffix,
            maxTokens: maxTokens,
            temperature: temperature,
            topP: topP,
            n: n,
            stream: stream,
            logprobs: logprobs,
            echo: echo,
            stops: stops,
            presencePenalty: presencePenalty,
            frequencyPenalty: frequencyPenalty,
            bestOf: bestOf,
            logitBias: logitBias,
            user: user
        )
                
        self.body = .data(try Self.encoder.encode(body))
    }
}

extension CreateCompletionRequest {
    struct Body: Encodable {
        let model: String
        let prompts: [String]
        let suffix: String?
        let maxTokens: Int
        let temperature: Double
        let topP: Double
        let n: Int
        let stream: Bool
        let logprobs: Int?
        let echo: Bool
        let stops: [String]
        let presencePenalty: Double
        let frequencyPenalty: Double
        let bestOf: Int
        let logitBias: [String: Int]
        let user: String?
            
        enum CodingKeys: CodingKey {
            case model
            case prompt
            case suffix
            case maxTokens
            case temperature
            case topP
            case n
            case stream
            case logprobs
            case echo
            case stop
            case presencePenalty
            case frequencyPenalty
            case bestOf
            case logitBias
            case user
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(model, forKey: .model)
            
           if !prompts.isEmpty {
                try container.encode(prompts, forKey: .prompt)
            }
            
            try container.encodeIfPresent(suffix, forKey: .suffix)
            try container.encode(maxTokens, forKey: .maxTokens)
            try container.encode(temperature, forKey: .temperature)
            try container.encode(topP, forKey: .topP)
            try container.encode(n, forKey: .n)
            try container.encode(stream, forKey: .stream)
            try container.encodeIfPresent(logprobs, forKey: .logprobs)
            try container.encode(echo, forKey: .echo)
            
            if !stops.isEmpty {
                try container.encode(stops, forKey: .stop)
            }
            
            try container.encode(presencePenalty, forKey: .presencePenalty)
            try container.encode(frequencyPenalty, forKey: .frequencyPenalty)
            try container.encode(bestOf, forKey: .bestOf)
            
            if !logitBias.isEmpty {
                try container.encode(logitBias, forKey: .logitBias)
            }
            
            try container.encodeIfPresent(user, forKey: .user)
        }
    }
}
