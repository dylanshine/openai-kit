import Foundation

public struct Image {
    public let url: String
}

extension Image: Decodable {}

extension Image {
    public enum Size: String {
        case twoFiftySix = "256x256"
        case fiveTwelve = "512x512"
        case tenTwentyFour = "1024x1024"
    }
}

extension Image.Size: Codable {}
