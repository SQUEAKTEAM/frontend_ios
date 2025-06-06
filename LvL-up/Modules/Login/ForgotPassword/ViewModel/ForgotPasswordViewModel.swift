//
//  ForgotPasswordViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 15.02.2024.
//

import Foundation

protocol ResetPasswordAllow {
    func sendCodeOn(mail: String) async throws -> Int
    func resetPassword(mail: String, password: String) async throws -> Bool
}

class ForgotPasswordViewModel: ObservableObject {
    private let interactor: ForgotPasswordInteractorProtocol
    
    @Published var mail: String = ""
    
    @Published var code: Int?
    @Published var internalCode: String = ""
    
    @Published var password1: String = ""
    @Published var password2: String = ""
    
    @Published var alertStatus: AlertStatus?
    @Published var customErrorDescription: String?
    
    @Published var state: State = .mail
    
    init(state: State = .mail, interactor: ForgotPasswordInteractorProtocol = ForgotPasswordInteractor()) {
        self.interactor = interactor
        self.state = state
    }
    
    enum State: Int {
        case closed = 0
        case mail
        case code
        case reset
        case ready
        
        func changeState() -> State {
            switch self {
            case .closed: return .mail
            case .mail: return .code
            case .code: return .reset
            case .reset: return .ready
            case .ready: return .closed
            }
        }
    }
    
    enum AlertStatus: String {
        case noEqualPassword = "Пароли не совпадают!"
        case smallPassword   = "Пароль должен содержать не менее 8 символов!"
        case noEqualCode     = "Код не совпадает!"
        case noExistCode     = "Проблемы с приходом кода!"
        case invalidedCode   = "Проверьте правильность ввода кода!"
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
    
    //MARK: - USER INTENT(S)
    func changeState() {
        state = state.changeState()
    }
    func close() {
        mail = ""
        code = nil
        internalCode = ""
        password1 = ""
        password2 = ""
        state = .closed
    }
    
    @MainActor
    func sendCode() async {
        do {
            code = try await interactor.sendCodeOn(mail: mail)
            changeState()
        } catch {
            customErrorDescription = error.localizedDescription
            alertStatus = .custom
        }
    }
    
    func codeButtonAction() {
        
        guard let code = code else {
            alertStatus = .noExistCode
            return
        }
        
        guard let internalCode = Int(internalCode) else {
            alertStatus = .invalidedCode
            return
        }
        
        
        if code == internalCode {
            self.internalCode = ""
            self.code = nil
            self.changeState()
        } else {
            alertStatus = .noEqualCode
        }
    }
    
    func resetButtonAction() async {
        if checkInDataResetButton() {
            do {
                if try await interactor.resetPassword(mail: mail, password: password1) {
                    changeState()
                }
            } catch {
                customErrorDescription = error.localizedDescription
                alertStatus = .custom
            }
        }
    }
    
    private func checkInDataResetButton() -> Bool {
        if password1.count < 8 || password2.count < 8 {
            alertStatus = .smallPassword
            return false
        }
        if password1 != password2 {
            alertStatus = .noEqualPassword
            return false
        }
        return true
    }
    
    func readyButtonAction() {
        changeState()
    }
}
