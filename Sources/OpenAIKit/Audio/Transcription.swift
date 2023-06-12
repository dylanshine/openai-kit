//
//  Audio.swift
//
//
//  Created by Joshua Galvan on 6/12/23.
//


import Foundation

/**
 Audio
 Learn how to turn audio into text.

 Related guide: https://platform.openai.com/docs/guides/speech-to-text
 */

public struct Transcription {
    public let text: String
}

extension Transcription: Codable {}
