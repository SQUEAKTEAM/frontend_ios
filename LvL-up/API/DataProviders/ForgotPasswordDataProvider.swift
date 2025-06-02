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
        let _: String = try await apiManager.postText("api/password/reset/", body: UserResetPasswordDto(email: mail, password: password))
        return true
    }
    
    func sendCodeOn(mail: String) async throws -> Int {
        let strCode: CodeDto = try await apiManager.post("api/send-code/", body: EmailDto(email: mail))
        guard let code = Int(strCode.verificationCode) else { throw URLError(.badURL) }
        return code
    }
}

struct UserResetPasswordDto: Codable {
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case email = "Email"
        case password = "NewPassword"
    }
}

struct CodeDto: Codable {
    let verificationCode: String
}

struct EmailDto: Codable {
    let email: String
}
