import Foundation

/**
 Given a prompt, the model will return one or more predicted completions, and can also return the probabilities of alternative tokens at each position.
 */
public struct Completion {
    public let id: String
    public let object: String
    public let created: Date
    public let model: String
    public let choices: [Choice]
    public let usage: Usage
}

extension Completion: Codable {}

extension Completion {
    public struct Choice {
        public let text: String
        public let index: Int
        public let logprobs: Logprobs?
        public let finishReason: String?
    }
}

extension Completion.Choice: Codable {}

extension Completion.Choice {
    public struct Logprobs {
        public let tokens: [String]
        public let tokenLogprobs: [Float]
        public let topLogprobs: [String: Float]
        public let textOffset: [Int]
    }
}

extension Completion.Choice.Logprobs: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tokens = try container.decodeIfPresent([String].self, forKey: .tokens) ?? []
        self.tokenLogprobs = try container.decodeIfPresent([Float].self, forKey: .tokenLogprobs) ?? []
        self.topLogprobs = try container.decodeIfPresent([String: Float].self, forKey: .topLogprobs) ?? [:]
        self.textOffset = try container.decodeIfPresent([Int].self, forKey: .textOffset) ?? []
    }
}
