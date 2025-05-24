//
//  LoginPresenter.swift
//  LvL-up
//
//  Created by MyBook on 12.05.2025.
//

import SwiftUI

class LoginPresenter: ObservableObject {
    private let interactor: LoginInteractorProtocol
    private let router: LoginRouterProtocol
//    var apiService: APIManager
//    @Published var user: User? = nil
    @Published var mail: String = ""
    
    @Published var password1: String = ""
    @Published var password2: String = ""
    
    @Published var alertStatus: AlertStatus?
    @Published var customErrorDescription: String?
    
    enum AlertStatus: String {
        case noEqualPassword = "Пароли не совпадают!"
        case smallPassword   = "Пароль должен содержать не менее 8 символов!"
        case usernameIsEmpty = "Введите имя пользователя!"
        case noExistMail     = "Данной почты не существует!"
        case custom = ""
    }
    
    func errorText(_ status: AlertStatus?) -> String? {
        guard let status = status else { return nil }
        switch status {
        case .custom: return customErrorDescription
        default: return status.rawValue
        }
    }
    
    init(interactor: LoginInteractorProtocol = LoginInteractor(), router: LoginRouterProtocol = LoginRouter()) {
        self.interactor = interactor
        self.router = router
//        self.authService = AuthManager.instance
//        self.apiService = APIManager.instance
//        self.user = user
    }
    
    // MARK: - User Intents
    func login() async -> Bool {
        if await !interactor.login(mail: "string", password: "string") {
            customErrorDescription = "Неверный логин или пароль"
            alertStatus = .custom
            return false
        }
        return true
    }
    
    func register() async -> Bool {
        if await !interactor.register(mail: mail, password: password1) {
            customErrorDescription = "Неверный логин или пароль"
            alertStatus = .custom
            return false
        }
        return true
    }
    
    func navigateToHomeScreen() -> AnyView {
        router.navigateToHomeScreen()
    }

    func checkCurrectData() -> Bool {
        if password1.count < 8 || password2.count < 8 {
            alertStatus = .smallPassword
            return false
        }
        if password1 != password2 {
            alertStatus = .noEqualPassword
            return false
        }
        if mail.isEmpty || !checkCurrectUsername() {
            alertStatus = .usernameIsEmpty
            return false
        }
        
        return true
    }
    
    private func checkCurrectUsername() -> Bool {
        for i in mail {
            if i != " " {
                return true
            }
        }
        return false
    }
}
