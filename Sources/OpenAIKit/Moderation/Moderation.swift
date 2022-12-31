import Foundation

/**
 Moderations
 Given a input text, outputs if the model classifies it as violating OpenAI's content policy.
 */

public struct Moderation {
    public let id: String
    public let model: String
    public let results: [Moderation.Result]
}

extension Moderation {
    public struct Result {
        public let categories: Categories
        public let categoryScores: CategoryScores
        public let flagged: Bool
    }
    
    public enum Model: String, Codable {
        case latest = "text-moderation-latest"
        case stable = "text-moderation-stable"
    }
}

extension Moderation.Result {
    public struct Categories {
        public let hate: Bool
        public let hateThreatening: Bool
        public let selfHarm: Bool
        public let sexual: Bool
        public let sexualMinors: Bool
        public let violence: Bool
        public let violenceGraphic: Bool
    }
    
    public struct CategoryScores {
        public let hate: Float
        public let hateThreatening: Float
        public let selfHarm: Float
        public let sexual: Float
        public let sexualMinors: Float
        public let violence: Float
        public let violenceGraphic: Float
    }
}

extension Moderation: Decodable {}
extension Moderation.Result: Decodable {}

enum ModerationCategoryCodingKeys: String, CodingKey {
    case hate
    case hateThreatening = "hate/threatening"
    case selfHarm = "self-harm"
    case sexual
    case sexualMinors = "sexual/minors"
    case violence
    case violenceGraphic = "violence/graphic"
}

extension Moderation.Result.Categories: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ModerationCategoryCodingKeys.self)
        self.hate = try container.decode(Bool.self, forKey: .hate)
        self.hateThreatening = try container.decode(Bool.self, forKey: .hateThreatening)
        self.selfHarm = try container.decode(Bool.self, forKey: .selfHarm)
        self.sexual = try container.decode(Bool.self, forKey: .sexual)
        self.sexualMinors = try container.decode(Bool.self, forKey: .sexualMinors)
        self.violence = try container.decode(Bool.self, forKey: .violence)
        self.violenceGraphic = try container.decode(Bool.self, forKey: .violenceGraphic)
    }
}

extension Moderation.Result.CategoryScores: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ModerationCategoryCodingKeys.self)
        self.hate = try container.decode(Float.self, forKey: .hate)
        self.hateThreatening = try container.decode(Float.self, forKey: .hateThreatening)
        self.selfHarm = try container.decode(Float.self, forKey: .selfHarm)
        self.sexual = try container.decode(Float.self, forKey: .sexual)
        self.sexualMinors = try container.decode(Float.self, forKey: .sexualMinors)
        self.violence = try container.decode(Float.self, forKey: .violence)
        self.violenceGraphic = try container.decode(Float.self, forKey: .violenceGraphic)
    }
}
