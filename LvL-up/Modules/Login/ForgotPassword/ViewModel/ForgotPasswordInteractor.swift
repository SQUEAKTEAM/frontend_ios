//
//  ForgotPasswordInteractor.swift
//  LvL-up
//
//  Created by MyBook on 21.05.2025.
//

import Foundation

protocol ForgotPasswordProviderProtocol: ResetPasswordAllow {}

protocol ForgotPasswordInteractorProtocol {
    func resetPassword(mail: String, password: String) async throws -> Bool
    func sendCodeOn(mail: String) async throws -> Int
}

final class ForgotPasswordInteractor: ForgotPasswordInteractorProtocol {
    private let dataService: ForgotPasswordProviderProtocol
    
    init(dataService: ForgotPasswordProviderProtocol = ForgotPasswordDataProvider()) {
        self.dataService = dataService
    }
    
    func resetPassword(mail: String, password: String) async throws -> Bool {
        try await dataService.resetPassword(mail: mail, password: password)
    }
    
    func sendCodeOn(mail: String) async throws -> Int {
        try await dataService.sendCodeOn(mail: mail)
    }
    
}
