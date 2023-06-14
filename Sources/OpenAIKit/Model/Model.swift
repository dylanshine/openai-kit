import Foundation

/**
 List and describe the various models available in the API.
 */
public struct Model: Codable {
    public let id: String
    public let object: String
    public let created: Date
    public let ownedBy: String
    public let permission: [Permission]
    public let root: String
    public let parent: String?
}

extension Model {
    public struct Permission: Codable {
        public let id: String
        public let object: String
        public let created: Date
        public let allowCreateEngine: Bool
        public let allowSampling: Bool
        public let allowLogprobs: Bool
        public let allowSearchIndices: Bool
        public let allowView: Bool
        public let allowFineTuning: Bool
        public let organization: String
        public let group: String?
        public let isBlocking: Bool
    }
}

public protocol ModelID {
    var id: String { get }
}

extension Model {
    public enum GPT4: String, ModelID {
        case gpt4 = "gpt-4"
        case gpt40314 = "gpt-4-0314"
        case gpt4_32k = "gpt-4-32k"
        case gpt4_32k0314 = "gpt-4-32k-0314"
    }

    public enum GPT3: String, ModelID {
        case gpt3_5Turbo = "gpt-3.5-turbo"
        case gpt3_5Turbo16K = "gpt-3.5-turbo-16k"
        case gpt3_5Turbo0301 = "gpt-3.5-turbo-0301"
        case textDavinci003 = "text-davinci-003"
        case textDavinci002 = "text-davinci-002"
        case textCurie001 = "text-curie-001"
        case textBabbage001 = "text-babbage-001"
        case textAda001 = "text-ada-001"
        case textEmbeddingAda002 = "text-embedding-ada-002"
        case textDavinci001 = "text-davinci-001"
        case textDavinciEdit001 = "text-davinci-edit-001"
        case davinciInstructBeta = "davinci-instruct-beta"
        case davinci
        case curieInstructBeta = "curie-instruct-beta"
        case curie
        case ada
        case babbage
    }

    public enum Codex: String, ModelID {
        case codeDavinci002 = "code-davinci-002"
        case codeCushman001 = "code-cushman-001"
        case codeDavinci001 = "code-davinci-001"
        case codeDavinciEdit001 = "code-davinci-edit-001"
    }

    public enum Whisper: String, ModelID {
        case whisper1 = "whisper-1"
    }
}

extension RawRepresentable where RawValue == String {
    public var id: String {
        rawValue
    }
}
