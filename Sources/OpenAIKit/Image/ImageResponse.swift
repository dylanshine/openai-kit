import Foundation

public struct ImageResponse {
    public let created: Date
    public let data: [Image]
}

extension ImageResponse: Decodable {}
