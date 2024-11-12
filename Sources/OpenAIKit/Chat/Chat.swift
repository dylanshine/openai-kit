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
}

extension Chat.Choice: Codable {}

extension Chat {
    public struct Message {
        public let role: Role
        public let content: [Content]

        public init(role: Role, content: [Content]) {
            self.role = role
            self.content = content
        }
    }
}

extension Chat.Message {
    public enum Role: String, Codable {
        case system
        case user
        case assistant
    }
}

extension Chat.Message {
    public enum Content: Codable {
        /// Text content.
        case text(String)
        /// A URL to an image.
        case imageURL(URL)
        /// Base 64 ecoded image and the associated content type.
        case imageData(Data, String)
    }
}

extension Chat.Message.Content {
    public var text: String? {
        switch self {
        case .text(let text):
            return text
        default:
            return nil
        }
    }
    public var imageURL: URL? {
        switch self {
        case .imageURL(let url):
            return url
        default:
            return nil
        }
    }
    public var imageData: Data? {
        switch self {
        case .imageData(let data, _):
            return data
        default:
            return nil
        }
    }
    public var contentType: String? {
        switch self {
        case .imageData(_, let contentType):
            return contentType
        default:
            return nil
        }
    }
}

extension Chat.Message: Codable {
    private enum CodingKeys: String, CodingKey {
        case role
        case content
    }

    private enum ContentKeys: String, CodingKey {
        case type
        case text
        case imageURL = "image_url"
    }

    private enum ImageURLKeys: String, CodingKey {
        case url
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        role = try container.decode(Chat.Message.Role.self, forKey: .role)

        if let singleTextContent = try? container.decode(String.self, forKey: .content) {
            content = [.text(singleTextContent)]
        } else {
            var contentsArray = try container.nestedUnkeyedContainer(forKey: .content)
            var contents = [Content]()

            while !contentsArray.isAtEnd {
                let contentContainer = try contentsArray.nestedContainer(keyedBy: ContentKeys.self)
                let type = try contentContainer.decode(String.self, forKey: .type)

                switch type {
                case "text":
                    let text = try contentContainer.decode(String.self, forKey: .text)
                    contents.append(.text(text))
                case "image_url":
                    let imageURLContainer = try contentContainer.nestedContainer(keyedBy: ImageURLKeys.self, forKey: .imageURL)

                    if let url = try? imageURLContainer.decode(URL.self, forKey: .url) {
                        contents.append(.imageURL(url))
                    } else if let imageDataURL = try? imageURLContainer.decode(String.self, forKey: .url) {
                        let components = imageDataURL.components(separatedBy: ",")
                        if components.count == 2 {
                            let metadata = components[0]
                            let base64Component = components[1]

                            if
                                let base64Data = base64Component.data(using: .utf8),
                                let contentTypeRange = metadata.range(of: "data:")?.upperBound,
                                let base64IndicatorRange = metadata.range(of: ";base64")?.lowerBound
                            {
                                let contentType = String(metadata[contentTypeRange..<base64IndicatorRange])

                                contents.append(.imageData(base64Data, contentType))
                            }
                        }
                    } else {
                        throw DecodingError.dataCorruptedError(forKey: .type, in: contentContainer, debugDescription: "Unknown image URL")
                    }
                default:
                    throw DecodingError.dataCorruptedError(forKey: .type, in: contentContainer, debugDescription: "Unknown content type: \(type)")
                }
            }
            content = contents
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(role, forKey: .role)

        if content.count == 1, let text = content.first?.text {
            try container.encode(text, forKey: .content)
        } else {
            var contentsArray = container.nestedUnkeyedContainer(forKey: .content)
            for contentItem in content {
                var contentContainer = contentsArray.nestedContainer(keyedBy: ContentKeys.self)
                switch contentItem {
                case .text(let text):
                    try contentContainer.encode("text", forKey: .type)
                    try contentContainer.encode(text, forKey: .text)
                case .imageURL(let url):
                    try contentContainer.encode("image_url", forKey: .type)
                    var urlContainer = contentContainer.nestedContainer(keyedBy: ImageURLKeys.self, forKey: .imageURL)
                    try urlContainer.encode(url, forKey: .url)
                case .imageData(let data, let contentType):
                    try contentContainer.encode("image_url", forKey: .type)
                    var urlContainer = contentContainer.nestedContainer(keyedBy: ImageURLKeys.self, forKey: .imageURL)
                    let data = data.base64EncodedString()
                    let dataURL = "data:\(contentType);base64,\(data)"
                    try urlContainer.encode(dataURL, forKey: .url)
                }
            }
        }
    }
}
