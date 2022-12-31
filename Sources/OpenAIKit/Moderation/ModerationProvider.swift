public struct ModerationProvider {
    
    private let requestHandler: RequestHandler
    
    init(requestHandler: RequestHandler) {
        self.requestHandler = requestHandler
    }
    
    /**
     Create moderation
     POST
      
     https://api.openai.com/v1/moderations

     Classifies if text violates OpenAI's Content Policy
     */
    public func createModeration(
        input: String,
        model: Moderation.Model = .latest
    ) async throws -> Moderation {
        
        let request = try CreateModerationRequest(
            input: input,
            model: model
        )
        
        return try await requestHandler.perform(request: request)
    }
}
