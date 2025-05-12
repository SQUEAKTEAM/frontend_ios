//
//  AuthManager.swift
//  LvL-up
//
//  Created by MyBook on 12.05.2025.
//

import Foundation

final class AuthManager {
    static var instance = AuthManager()
}

extension AuthManager: ResetPasswordAllow, Registration {
    func register(username: String, mail: String, password: String) async -> String? {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        //createAnonymous()
        return nil
    }
    
    func resetPassword(mail: String, password: String) async throws -> Bool {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        return true
    }
    
    func sendCodeOn(mail: String) async throws -> Int {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        return 100_000
    }
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}
