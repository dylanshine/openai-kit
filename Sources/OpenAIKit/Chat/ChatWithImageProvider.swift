//
//  ChatWithImageProvider.swift
//
//
//  Created by 贺峰煜 on 2023/11/28.
//

import Foundation

public struct ChatWithImageProvider {
    private let requesthandler: RequestHandler
    
    init(requesthandler: RequestHandler) {
        self.requesthandler = requesthandler
    }
    
    /**
     Create chat completion
     POST
      
     https://api.openai.com/v1/chat/completions

     Creates a chat completion for the provided prompt and parameters
     */
    
    public func create(
        model: ModelID,
        message: [ChatWithImage.Message] = [],
        temperature: Double = 1.0,
        topP: Double = 1.0,
        n: Int = 1,
        stops: [String] = [],
        maxTokens: Int? = nil,
        presencePenalty: Double = 0.0,
        frequencyPenalty: Double = 0.0,
        logitBias: [String : Int] = [:],
        user: String? = nil
    ) async throws -> ChatWithImage {
        let request = try CreateChatWithImageRequest(
            model: model.id,
            messages: message,
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
        
        return try await requesthandler.perform(request: request)
    }
}
