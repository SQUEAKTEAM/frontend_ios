//
//  LoginDataProvider.swift
//  LvL-up
//
//  Created by MyBook on 21.05.2025.
//

import Foundation

final class LoginDataProvider: LoginProviderProtocol {

    private let apiManager: APIManager
    
    init(apiManager: APIManager = APIManager.shared) {
        self.apiManager = apiManager
    }
    
    func login(mail: String, password: String) async -> Bool {
        let tokens: TokenDto? = try? await apiManager.post("api/auth/login/", body: UserDto(email: mail, password: password))
        
        guard let tokens = tokens else { return false }
        
        apiManager.accessToken = tokens.accessToken
        apiManager.refreshToken = tokens.refreshToken
        
        return true
        //try? await Task.sleep(nanoseconds: 2_000_000_000)
        //return nil
    }
    
    func register(mail: String, password: String) async -> Bool {
        do {
            let _: EmptyResponse = try await apiManager.post("api/auth/register/", body: UserDto(email: mail, password: password))
            return true // Возвращаем true, если запрос выполнен успешно
        } catch {
            return false
        }
        
        //try? await Task.sleep(nanoseconds: 2_000_000_000)
        //createAnonymous()
        //return nil
    }
}

struct UserDto: Codable {
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case email = "Email"
        case password = "Password"
    }
}
