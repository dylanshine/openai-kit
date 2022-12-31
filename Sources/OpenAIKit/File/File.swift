import Foundation

/**
 Files are used to upload documents that can be used with features like Fine-tuning.
 */
public struct File {
    public let id: String
    public let bytes: Int
    public let createdAt: Date
    public let filename: String
    public let object: String
    public let owner: String?
    public let purpose: Purpose
}

extension File {
    public enum Purpose: String {
        case fineTune = "fine-tune"
        case answers
        case search
        case classifications
    }
}

extension File: Codable {}
extension File.Purpose: Codable {}
