//
//  CreateTranscriptionRequest.swift
//  
//
//  Created by Dylan Shine on 3/19/23.
//

import NIOHTTP1
import Foundation
import AsyncHTTPClient

struct CreateTranscriptionRequest: Request {
    let method: HTTPMethod = .POST
    let path = "/v1/audio/transcriptions"
    let body: Data?
    private let boundary = UUID().uuidString
    
    var headers: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "multipart/form-data; boundary=\(boundary)")
        return headers
    }
    
    init(
        file: Data,
        fileName: String,
        mimeType: MIMEType.Audio,
        model: ModelID,
        prompt: String?,
        responseFormat: String?,
        temperature: Double?,
        language: Language?
    ) {
        let builder = MultipartFormDataBuilder(boundary: boundary)
        
        builder.addDataField(
            fieldName:  "file",
            fileName: fileName,
            data: file,
            mimeType: mimeType.rawValue
        )
        
        builder.addTextField(named: "model", value: model.id)
        
        if let prompt = prompt {
            builder.addTextField(named: "prompt", value: prompt)
        }
        
        if let responseFormat = responseFormat {
            builder.addTextField(named: "response_format", value: responseFormat)
        }
        
        if let temperature = temperature {
            builder.addTextField(named: "temperature", value: String(temperature))
        }
        
        if let language = language {
            builder.addTextField(named: "language", value: language.rawValue)
        }

        self.body = builder.build()
    }
}

