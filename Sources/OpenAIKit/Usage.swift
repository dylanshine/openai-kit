import Foundation

public struct Usage {
    public let promptTokens: Int
    public let completionTokens: Int
    public let totalTokens: Int
}

extension Usage: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.promptTokens = try container.decodeIfPresent(Int.self, forKey: .promptTokens) ?? -1
        self.completionTokens = try container.decodeIfPresent(Int.self, forKey: .completionTokens) ?? -1
        self.totalTokens = try container.decodeIfPresent(Int.self, forKey: .totalTokens) ?? -1
    }
}
