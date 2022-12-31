public struct ModelProvider {
    
    private let requestHandler: RequestHandler
    
    init(requestHandler: RequestHandler) {
        self.requestHandler = requestHandler
    }
    
    /**
     List models
     GET
      
     https://api.openai.com/v1/models

     Lists the currently available models, and provides basic information about each one such as the owner and availability.
     */
    public func list() async throws -> [Model] {
        let request = ListModelsRequest()
        
        let response: ListModelsResponse = try await requestHandler.perform(request: request)
        
        return response.data
    }
    
    /**
     Retrieve model
     GET
      
     https://api.openai.com/v1/models/{model}

     Retrieves a model instance, providing basic information about the model such as the owner and permissioning.
     */
    public func retrieve(id: String) async throws -> Model {
        let request = RetrieveModelRequest(id: id)
    
        return try await requestHandler.perform(request: request)
    }
    
}
