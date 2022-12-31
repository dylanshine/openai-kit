public struct CompletionProvider {
    
    private let requestHandler: RequestHandler
    
    init(requestHandler: RequestHandler) {
        self.requestHandler = requestHandler
    }
    
    /**
     Create completion
     POST
      
     https://api.openai.com/v1/completions

     Creates a completion for the provided prompt and parameters
     */
    public func create(
        model: ModelID,
        prompts: [String] = [],
        suffix: String? = nil,
        maxTokens: Int = 16,
        temperature: Double = 1.0,
        topP: Double = 1.0,
        n: Int = 1,
        stream: Bool = false,
        logprobs: Int? = nil,
        echo: Bool = false,
        stops: [String] = [],
        presencePenalty: Double = 0.0,
        frequencyPenalty: Double = 0.0,
        bestOf: Int = 1,
        logitBias: [String : Int] = [:],
        user: String? = nil
    ) async throws -> Completion {
        
        let request = try CreateCompletionRequest(
            model: model.id,
            prompts: prompts,
            suffix: suffix,
            maxTokens: maxTokens,
            temperature: temperature,
            topP: topP,
            n: n,
            stream: stream,
            logprobs: logprobs,
            echo: echo,
            stops: stops,
            presencePenalty: presencePenalty,
            frequencyPenalty: frequencyPenalty,
            bestOf: bestOf,
            logitBias: logitBias,
            user: user
        )
        
        return try await requestHandler.perform(request: request)
        
    }
}
