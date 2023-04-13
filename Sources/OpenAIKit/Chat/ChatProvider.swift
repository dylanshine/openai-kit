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
            stream: false,
            stops: stops,
            maxTokens: maxTokens,
            presencePenalty: presencePenalty,
            frequencyPenalty: frequencyPenalty,
            logitBias: logitBias,
            user: user
        )
    
        return try await requestHandler.perform(request: request)

    }
    
    /**
     Create chat completion
     POST
      
     https://api.openai.com/v1/chat/completions

     Creates a chat completion for the provided prompt and parameters
     
     stream If set, partial message deltas will be sent, like in ChatGPT.
     Tokens will be sent as data-only server-sent events as they become available, with the stream terminated by a data: [DONE] message.
     
     https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events#event_stream_format
     */
    public func stream(
        model: ModelID,
        messages: [Chat.Message] = [],
        temperature: Double = 1.0,
        topP: Double = 1.0,
        n: Int = 1,
        stops: [String] = [],
        maxTokens: Int? = nil,
        presencePenalty: Double = 0.0,
        frequencyPenalty: Double = 0.0,
        logitBias: [String : Int] = [:],
        user: String? = nil
    ) async throws -> AsyncThrowingStream<ChatStream, Error> {
        
        let request = try CreateChatRequest(
            model: model.id,
            messages: messages,
            temperature: temperature,
            topP: topP,
            n: n,
            stream: true,
            stops: stops,
            maxTokens: maxTokens,
            presencePenalty: presencePenalty,
            frequencyPenalty: frequencyPenalty,
            logitBias: logitBias,
            user: user
        )
    
        return try await requestHandler.stream(request: request)
                
    }
}
