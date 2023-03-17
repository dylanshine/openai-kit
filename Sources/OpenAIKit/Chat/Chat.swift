import Foundation

/**
 Given a prompt, the model will return one or more predicted chat completions, and can also return the probabilities of alternative tokens at each position.
 */
public struct Chat {
    public let id: String
    public let object: String
    public let created: Date
    public let model: String
    public let choices: [Choice]
    public let usage: Usage
}

extension Chat: Codable {}

extension Chat {
    public struct Choice {
        public let index: Int
        public let message: Message
        public let finishReason: FinishReason?
        
        public enum FinishReason: String {
            /// API returned complete model output
            case stop
            
            /// Incomplete model output due to max_tokens parameter or token limit
            case length
            
            /// Omitted content due to a flag from our content filters
            case contentFilter = "content_filter"
        }
    }
}

extension Chat.Choice: Codable {}

extension Chat.Choice.FinishReason: Codable {}

extension Chat {
    public enum Message {
        case system(content: String)
        case user(content: String)
        case assistant(content: String)
    }
}

extension Chat.Message: Codable {
    private enum CodingKeys: String, CodingKey {
        case role
        case content
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let role = try container.decode(String.self, forKey: .role)
        let content = try container.decode(String.self, forKey: .content)
        switch role {
        case "system":
            self = .system(content: content)
        case "user":
            self = .user(content: content)
        case "assistant":
            self = .assistant(content: content)
        default:
            throw DecodingError.dataCorruptedError(forKey: .role, in: container, debugDescription: "Invalid type")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .system(let content):
            try container.encode("system", forKey: .role)
            try container.encode(content, forKey: .content)
        case .user(let content):
            try container.encode("user", forKey: .role)
            try container.encode(content, forKey: .content)
        case .assistant(let content):
            try container.encode("assistant", forKey: .role)
            try container.encode(content, forKey: .content)
        }
    }
}
