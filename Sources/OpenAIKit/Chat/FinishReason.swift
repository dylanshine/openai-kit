import Foundation

public enum FinishReason: String {
    /// API returned complete model output
    case stop
    
    /// Incomplete model output due to max_tokens parameter or token limit
    case length
    
    /// Omitted content due to a flag from our content filters
    case contentFilter = "content_filter"
}

extension FinishReason: Codable {}
