public struct ChatProvider {
    
    private let requestHandler: RequestHandler
    
    init(requestHandler: RequestHandler) {
        self.requestHandler = requestHandler
    }
    
    /**
     Create chat completion
     POST
      
     https://api.openai.com/v1/chat/completions

     Creates a chat completion for the provided prompt and parameters
     */
    public func create(
        model: ModelID,
        messages: [Chat.Message] = [],
        temperature: Double = 1.0,
        topP: Double = 1.0,
        n: Int = 1,
        stream: Bool = false,
        stops: [String] = [],
        maxTokens: Int? = nil,
        presencePenalty: Double = 0.0,
        frequencyPenalty: Double = 0.0,
        logitBias: [String : Int] = [:],
        user: String? = nil
    ) async throws -> Chat {
        
        let request = try CreateChatRequest(
            model: model.id,
            messages: messages,
            temperature: temperature,
            topP: topP,
            n: n,
            stream: stream,
            stops: stops,
            maxTokens: maxTokens,
            presencePenalty: presencePenalty,
            frequencyPenalty: frequencyPenalty,
            logitBias: logitBias,
            user: user
        )
        let chat: Chat = try await requestHandler.perform(request: request)
        
        return chat
        
    }
}
