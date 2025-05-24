//
//  LoginInteractor.swift
//  LvL-up
//
//  Created by MyBook on 21.05.2025.
//

import Foundation

protocol Registration {
    func register(mail: String, password: String) async -> Bool
    func login(mail: String, password: String) async -> Bool
}

protocol LoginProviderProtocol: Registration {}

protocol LoginInteractorProtocol {
    func register(mail: String, password: String) async -> Bool
    func login(mail: String, password: String) async -> Bool
}

final class LoginInteractor: LoginInteractorProtocol {
    private let dataService: LoginProviderProtocol
    
    init(dataService: LoginProviderProtocol = LoginDataProvider()) {
        self.dataService = dataService
    }
    
    func register(mail: String, password: String) async -> Bool {
        await dataService.register(mail: mail, password: password)
    }
    
    func login(mail: String, password: String) async -> Bool {
        return await dataService.login(mail: mail, password: password)
    }
}
