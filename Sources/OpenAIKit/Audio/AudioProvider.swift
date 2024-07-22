//
//  AudioProvider.swift
//
//
//  Created by Dylan Shine on 3/19/23.
//

import Foundation

public struct AudioProvider {

    private let requestHandler: RequestHandler

    init(requestHandler: RequestHandler) {
        self.requestHandler = requestHandler
    }

    /**
     Create transcription BETA
     POST

     https://api.openai.com/v1/audio/transcriptions

     Transcribes audio into the input language.
     */
    public func transcribe(
        file: Data,
        fileName: String,
        mimeType: MIMEType.Audio,
        model: ModelID = Model.Whisper.whisper1,
        prompt: String? = nil,
        responseFormat: String? = nil,
        temperature: Double? = nil,
        language: Language? = nil
    ) async throws -> Transcription {

        let request = CreateTranscriptionRequest(
            file: file,
            fileName: fileName,
            mimeType: mimeType,
            model: model,
            prompt: prompt,
            responseFormat: responseFormat,
            temperature: temperature,
            language: language
        )

        return try await requestHandler.perform(request: request)
    }

    /**
     Create translation BETA
     POST

     https://api.openai.com/v1/audio/translations

     Translates audio into into English.
     */
    public func translate(
        file: Data,
        fileName: String,
        mimeType: MIMEType.Audio,
        model: ModelID = Model.Whisper.whisper1,
        prompt: String? = nil,
        responseFormat: String? = nil,
        temperature: Double? = nil
    ) async throws -> Translation {

        let request = CreateTranslationRequest(
            file: file,
            fileName: fileName,
            mimeType: mimeType,
            model: model,
            prompt: prompt,
            responseFormat: responseFormat,
            temperature: temperature
        )

        return try await requestHandler.perform(request: request)
    }
}
