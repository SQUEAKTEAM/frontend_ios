//
//  SendCodeOnMailView.swift
//  LMS_Mobile
//
//  Created by MyBook on 02.07.2024.
//

import SwiftUI

struct SendCodeOnMailView: View {
    
    @ObservedObject private var vm: SendCodeOnMailViewModel
    
    @State var isShowAlert = false
    @Binding var isOpen: Bool
    init(isOpen: Binding<Bool>, mail: Binding<String>, completion: @escaping () -> Void) {
        self._isOpen = isOpen
        self._vm = ObservedObject(wrappedValue: SendCodeOnMailViewModel(mail: mail, completion: completion))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            if vm.isOpen {
                codeSegment
            }
            
            Spacer()
        }
        .onChange(of: isOpen, perform: { bool in
            vm.isOpen = bool
        })
        .presentAsBottomSheet($vm.isOpen, maxHeight: 350)
        .withErrorAlert(alertStatus: $vm.alertStatus)
    }
}

#Preview {
    ZStack {
        SendCodeOnMailView(isOpen: .constant(true), mail: .constant("mail"), completion: {
            
        })
    }
}

extension SendCodeOnMailView {
    var codeSegment: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Введите код, который пришёл на вашу почту:")
                    .foregroundStyle(.secondary)
                    .padding(.leading)
                Spacer()
            }
            CodeTextFields(code: $vm.internalCode)
            
            TimerView(action: {
                Task {
                    await vm.sendCode()
                }
            })
            
            Spacer()
            
            ForgotPasswordBottomButton(title: "Подтвердить") {
                vm.codeButtonAction()
            }
        }
        .frame(height: 230)
    }
}

