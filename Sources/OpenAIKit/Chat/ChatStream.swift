import Foundation

public struct ChatStream {
    public let id: String
    public let object: String
    public let created: Date
    public let model: String
    public let choices: [ChatStream.Choice]
}

extension ChatStream: Codable {}

extension ChatStream {
    public struct Choice {
        public let index: Int
        public let finishReason: FinishReason?
        public let delta: ChatStream.Choice.Message
    }
}

extension ChatStream.Choice: Codable {}

extension ChatStream.Choice {
    public struct Message {
        public let content: String?
        public let role: String?
    }
}

extension ChatStream.Choice.Message: Codable {}


