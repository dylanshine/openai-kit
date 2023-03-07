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
        model: ModelID = Model.GPT3.gpt3_5Turbo,
        messages: [Chat.Message],
        temperature: Double? = nil,
        topP: Double? = nil,
        n: Int? = nil,
        stream: Bool? = nil,
        stop: [String]? = nil,
        maxTokens: Int? = nil,
        presencePenalty: Double? = nil,
        frequencyPenalty: Double? = nil,
        logitBias: [String : Int]? = nil,
        user: String? = nil
    ) async throws -> Chat {
        
        let request = try CreateChatRequest(
            model: model.id,
            messages: messages,
            temperature: temperature,
            topP: topP,
            n: n,
            stream: stream,
            stop: stop,
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
