//
//  AlertStatus.swift
//  LvL-up
//
//  Created by MyBook on 16.05.2025.
//

import Foundation

enum AlertStatus: Equatable {
    case noEqualCode
    case noExistCode
    case invalidCode
    case custom(String)  // Любое кастомное сообщение
    case error(EquatableError)    // Любая Swift-ошибка
    
    var message: String {
        switch self {
        case .noEqualCode: return "Код не совпадает!"
        case .noExistCode: return "Проблемы с приходом кода!"
        case .invalidCode: return "Проверьте правильность ввода кода!"
        case .custom(let text): return text
        case .error(let equatableError): return equatableError.error.localizedDescription
        }
    }
}

struct EquatableError: Equatable {
    let error: Error
    
    static func == (lhs: EquatableError, rhs: EquatableError) -> Bool {
        lhs.error.localizedDescription == rhs.error.localizedDescription
    }
}
