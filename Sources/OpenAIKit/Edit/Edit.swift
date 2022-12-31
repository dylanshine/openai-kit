import Foundation

/**
 Given a prompt and an instruction, the model will return an edited version of the prompt.
 */
public struct Edit {
    public let object: String
    public let created: Date
    public let usage: Usage
    public let choices: [Choice]
}

extension Edit {
    public struct Choice {
        public let text: String
        public let index: Int
    }
}

extension Edit: Codable {}
extension Edit.Choice: Codable {}
