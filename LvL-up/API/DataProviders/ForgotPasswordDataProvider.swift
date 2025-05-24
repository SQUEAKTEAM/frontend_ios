//
//  ForgotPasswordDataProvider.swift
//  LvL-up
//
//  Created by MyBook on 21.05.2025.
//

import Foundation

final class ForgotPasswordDataProvider: ForgotPasswordProviderProtocol {
    private let apiManager: APIManager
    
    init(apiManager: APIManager = APIManager.shared) {
        self.apiManager = apiManager
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
