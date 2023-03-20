//
//  Audio.swift
//  
//
//  Created by Dylan Shine on 3/19/23.
//


import Foundation

/**
 Audio
 Learn how to turn audio into text.

 Related guide: https://platform.openai.com/docs/guides/speech-to-text
 */

public struct Audio {
    public let text: String
}

extension Audio: Codable {}
