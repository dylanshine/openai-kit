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
        public let finishReason: String?
    }
}

extension Chat.Choice: Codable {}

extension Chat {
    public struct Message {
        public let role: String
        public let content: String
        public init(role: String, content: String) {
            self.role = role
            self.content = content
        }
    }
}

extension Chat.Message: Codable {}
