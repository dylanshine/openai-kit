//
//  MIMEType.swift
//
//
//  Created by Dylan Shine on 3/19/23.
//

import Foundation

public enum MIMEType {

    public enum File: String {
        case json = "application/json"
    }

    public enum Audio: String {
        case mpeg = "audio/mpeg"
        case mp4 = "audio/mp4"
        case wav = "audio/wav"
        case webm = "audio/webm"
        case m4a = "audio/m4a"
    }

}

extension MIMEType.File: Codable {}

extension MIMEType.Audio: Codable {}
