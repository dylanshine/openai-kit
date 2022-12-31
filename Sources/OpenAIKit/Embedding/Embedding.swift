import Foundation

/**
 Get a vector representation of a given input that can be easily consumed by machine learning models and algorithms.
 */
public struct Embedding {
    public let object: String
    public let embedding: [Float]
    public let index: Int
}

extension Embedding: Codable {}
