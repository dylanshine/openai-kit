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
    }
    
    public struct ImageUrl: Codable {
        public let url: String
        
        public init(url: String) {
            self.url = url
        }
    }
}

extension Chat.Choice: Codable {}

extension Chat {
    public enum Message {
        case system(content: String)
        case user(content: String)
        case assistant(content: String)
    }
    
    public enum MessageWithImage {
        case system(content: String)
        case user(content: [Content])
        case assistant(content: String)
    }
    
    public enum Content {
        case text(String)
        case imageUrl(ImageUrl)
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

extension Chat.Message {
    public var content: String {
        get {
            switch self {
            case .system(let content), .user(let content), .assistant(let content):
                return content
            }
        }
        set {
            switch self {
            case .system: self = .system(content: newValue)
            case .user: self = .user(content: newValue)
            case .assistant: self = .assistant(content: newValue)
            }
        }
    }
}

extension Chat.MessageWithImage: Codable {
    private enum CodingKeys: String, CodingKey {
        case role
        case content
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let role = try container.decode(String.self, forKey: .role)
        switch role {
        case "system":
            let content = try container.decode(String.self, forKey: .content)
            self = .system(content: content)
        case "user":
            let content = try container.decode([Chat.Content].self, forKey: .content)
            self = .user(content: content)
        case "assistant":
            let content = try container.decode(String.self, forKey: .content)
            self = .assistant(content: content)
        default:
            throw DecodingError.dataCorruptedError(forKey: .role, in: container, debugDescription: "Invalid role")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .system(content: let content):
            try container.encode("system", forKey: .role)
            try container.encode(content, forKey: .content)
        case .assistant(content: let content):
            try container.encode("assistant", forKey: .role)
            try container.encode(content, forKey: .content)
        case .user(content: let content):
            try container.encode("user", forKey: .role)
            try container.encode(content, forKey: .content)
        }
    }
}

extension Chat.Content: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case text
        case imageUrl = "image_url"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "text":
            let text = try container.decode(String.self, forKey: .text)
            self = .text(text)
        case "image_url":
            let imageUrl = try container.decode(Chat.ImageUrl.self, forKey: .imageUrl)
            self = .imageUrl(imageUrl)
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid type")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .text(let text):
            try container.encode("text", forKey: .type)
            try container.encode(text, forKey: .text)
        case .imageUrl(let imageUrl):
            try container.encode("image_url", forKey: .type)
            try container.encode(imageUrl, forKey: .imageUrl)
        }
    }
}

extension Chat.Content: Equatable {
    public static func ==(lhs: Chat.Content, rhs: Chat.Content) -> Bool {
        switch (lhs, rhs) {
        case (.text(let lhsText), .text(let rhsText)):
            return lhsText == rhsText
        case (.imageUrl(let lhsUrl), .imageUrl(let rhsUrl)):
            return lhsUrl.url == rhsUrl.url
        default:
            return false
        }
    }
}
