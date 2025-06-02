//
//  JSONDecoder.swift
//  LvL-up
//
//  Created by MyBook on 01.06.2025.
//

import Foundation

extension KeyedDecodingContainer {
    func decodeDateIfPresent(forKey key: Key) throws -> Date? {
        // Попробуем Unix timestamp (число)
        if let timestamp = try? decode(Double.self, forKey: key) {
            return Date(timeIntervalSince1970: timestamp)
        }
        
        // Попробуем строку ISO8601 (с миллисекундами или без)
        if let dateString = try? decode(String.self, forKey: key) {
            let formatterWithMillis = ISO8601DateFormatter()
            formatterWithMillis.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            let formatterWithoutMillis = ISO8601DateFormatter()
            formatterWithoutMillis.formatOptions = [.withInternetDateTime]
            
            return formatterWithMillis.date(from: dateString) ?? formatterWithoutMillis.date(from: dateString)
        }
        
        // Если поле отсутствует или null
        return nil
    }
}
