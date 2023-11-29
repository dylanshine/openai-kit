//
//  File.swift
//  
//
//  Created by 贺峰煜 on 2023/11/29.
//

import Foundation

public struct ChatWithImage {
    public let id: String
    public let object: String
    public let created: Date
    public let model: String
    public let choices: [Choice]
    public let usage: Usage
}

extension ChatWithImage: Codable {}

extension ChatWithImage {
    public struct Choice {
        public let index: Int
        public let message: Message
        public let finishReason: FinishReason?
    }
}

extension ChatWithImage.Choice: Codable {}

extension ChatWithImage {
    public enum Message {
        case system(content: String)
        case user(content: [Content])
        case assistant(content: String)
    }
    
    public enum Content {
        case text(String)
        case imageUrl(String)
    }
}

extension ChatWithImage.Message: Codable {
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
            let content = try container.decode([ChatWithImage.Content].self, forKey: .content)
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
        case .system(content: let content), .assistant(content: let content):
            try container.encode("text", forKey: .role)
            try container.encode(content, forKey: .content)
        case .user(content: let content):
            try container.encode("user", forKey: .role)
            try container.encode(content, forKey: .content)
        }
    }
}

extension ChatWithImage.Content: Codable {
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
            let imageUrl = try container.decode(String.self, forKey: .imageUrl)
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
            try container.encode("imageurl", forKey: .type)
            try container.encode(imageUrl, forKey: .imageUrl)
        }
    }
}

extension ChatWithImage.Content: Equatable {
    public static func ==(lhs: ChatWithImage.Content, rhs: ChatWithImage.Content) -> Bool {
        switch (lhs, rhs) {
        case (.text(let lhsText), .text(let rhsText)):
            return lhsText == rhsText
        case (.imageUrl(let lhsUrl), .imageUrl(let rhsUrl)):
            return lhsUrl == rhsUrl
        default:
            return false
        }
    }
}

