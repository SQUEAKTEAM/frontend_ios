//
//  SendCodeOnMailViewModel.swift
//  LMS_Mobile
//
//  Created by MyBook on 02.07.2024.
//

import SwiftUI

protocol SendCodeAllow {
    func sendCodeOn(mail: String) async throws -> Int
}

class SendCodeOnMailViewModel: ObservableObject, AlertHandling {
    @Published var alertStatus: AlertStatus?
    
    private let interactor: ForgotPasswordInteractorProtocol
    
    @Binding var mail: String
    @Published var code: Int? {
        didSet {
            if code != nil {
                isOpen = true
            } else {
                isOpen = false
            }
        }
    }
    
    @Published var isOpen = false {
        didSet {
            if isOpen && code == nil {
                Task {
                    await sendCode()
                }
            }
        }
    }
    
    @Published var internalCode: String = ""
    
    var completion: ()->Void
        
    init(mail: Binding<String>, interactor: ForgotPasswordInteractorProtocol = ForgotPasswordInteractor(), completion: @escaping ()->Void) {
        self.interactor = interactor
        self._mail = mail
        self.completion = completion
    }
    
    //MARK: - USER INTENT(S)
    func close() {
        code = nil
        internalCode = ""
    }
    
    
    func sendCode() async {        
        do {
            code = try await interactor.sendCodeOn(mail: mail)
        } catch {
            alertStatus = .error(EquatableError(error: error))
        }
    }
    
    func codeButtonAction() {
        
        guard let code = code else {
            alertStatus = .noExistCode
            return
        }
        
        guard let internalCode = Int(internalCode) else {
            alertStatus = .invalidCode
            return
        }
        
        if code == internalCode {
            close()
            completion()
        } else {
            alertStatus = .noEqualCode
        }
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
