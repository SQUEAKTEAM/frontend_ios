//
//  LoginPresenter.swift
//  LvL-up
//
//  Created by MyBook on 12.05.2025.
//

import Foundation

protocol Registration: SendCodeAllow {
    func register(username: String, mail: String, password: String) async -> String?
}

class LoginPresenter: ObservableObject {
//    var authService: AuthManager
//    var apiService: APIManager
//    @Published var user: User? = nil
    
    @Published var username: String = ""
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
    
    init() {
//        self.authService = AuthManager.instance
//        self.apiService = APIManager.instance
//        self.user = user
    }
    
    // MARK: - User Intents
    func login() async {
//        guard let error = await authService.getUserToken(login: username, password: password1) else {
//            guard let token = await authService.token else { return }
//            
//            guard let error = await apiService.getUser(id: token) else {
//                let user = await apiService.user
//                
//                await MainActor.run {
//                    self.user = user
//                }
//                return
//            }
//            
//            customErrorDescription = error
//            alertStatus = .custom
//            return
//        }
//        
//        customErrorDescription = "Неверный логин или пароль"
//        alertStatus = .custom
    }
    
    func register() async {
//        guard let error = await authService.register(username: username, mail: mail, password: password1) else {
//            await MainActor.run {
//                self.user = apiService.user
//            }
//            return
//        }
//        
//        customErrorDescription = error
//        alertStatus = .custom
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
        if username.isEmpty || !checkCurrectUsername() {
            alertStatus = .usernameIsEmpty
            return false
        }
        
        return true
    }
    
    private func checkCurrectUsername() -> Bool {
        for i in "username" {
            if i != " " {
                return true
            }
        }
        return false
    }
}
