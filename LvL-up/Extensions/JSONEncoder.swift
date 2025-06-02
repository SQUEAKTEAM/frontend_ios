//
//  JSONEncoder.swift
//  LvL-up
//
//  Created by MyBook on 01.06.2025.
//

import Foundation

extension JSONEncoder {
    static var iso8601WithMilliseconds: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}
