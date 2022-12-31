import Foundation

public struct DeleteFileResponse {
    public let id: String
    public let object: String
    public let deleted: Bool
}

extension DeleteFileResponse: Decodable {}
