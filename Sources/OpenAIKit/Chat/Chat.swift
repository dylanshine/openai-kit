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
        
        public enum FinishReason: String, Codable {
            /// API returned complete model output
            case stop
            
            /// Incomplete model output due to max_tokens parameter or token limit
            case length
            
            /// Omitted content due to a flag from our content filters
            case contentFilter
            
            enum CodingKeys: String, CodingKey  {
                case stop
                case length
                case contentFilter = "content_filter"
            }
        }
    }
}

extension Chat.Choice: Codable {}

extension Chat {
    public enum Message {
        case system(String)
        case user(String)
        case assistant(String)
    }
}

extension Chat.Message: Codable {}

extension Chat.Message {
    public enum Role: String, Codable {
        case system
        case user
        case assistant
    }
}
