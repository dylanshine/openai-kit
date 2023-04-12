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
        let index: Int
        let finishReason: FinishReason?
        let delta: ChatStream.Choice.Message
    }
}

extension ChatStream.Choice: Codable {}

extension ChatStream.Choice {
    public struct Message {
        let content: String?
        let role: String?
    }
}

extension ChatStream.Choice.Message: Codable {}


