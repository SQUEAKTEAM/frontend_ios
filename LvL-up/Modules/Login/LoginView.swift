//
//  LoginView.swift
//  LvL-up
//
//  Created by MyBook on 12.05.2025.
//

import SwiftUI
import SwiftfulUI

struct LoginView: View {
    @StateObject var presenter = LoginPresenter()
    
    @State private var isPresentHomeView = false
    @State var isShowAlert = false
    
    @State var forgotPasswordPresent = false
    @State var sendOnMailCodePresent: Int? = nil
    @State var isRegistration = false
    
    var body: some View {
        ZStack {
            
            LinearGradient(colors: [
                Color.background.opacity(0),
                Color.background.opacity(0.4),
                Color.background.opacity(1),
                
            
            ], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            
            VStack(spacing: 20) {
                loginButton
                HStack {
                    forgotPassword
                    Spacer()
                    swapButton
                }
                .padding(.horizontal)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(.keyboard, edges: .all)
            .padding(.horizontal, 20)
            
            textFieldsSegment
                .padding(.horizontal, 20)
            
            SendCodeOnMailView(code: $sendOnMailCodePresent, mail: presenter.mail) {
                isPresentHomeView = true
            }
            
        }
        .onChange(of: presenter.alertStatus) { status in
            guard let _ = status else { return }
            isShowAlert = true
        }
        .alert(presenter.errorText(presenter.alertStatus) ?? "", isPresented: $isShowAlert) {
            Button("OK", role: .cancel) {
                presenter.alertStatus = nil
            }
        }
        .fullScreenCover(isPresented: $isPresentHomeView) {
            HomeView()
        }
        .fullScreenCover(isPresented: $forgotPasswordPresent) {
            ForgotPasswordView(isOpen: $forgotPasswordPresent)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        //RouterView { _ in
            LoginView()
        //}
    }
}

extension LoginView {
    
    var textFieldsSegment: some View {
        VStack(spacing: 0) {
               
            TextField("Почта", text: $presenter.username)
                .textFieldStyle(text: $presenter.username)
            
            SecureField("Пароль", text: $presenter.password1)
                .textFieldStyle(text: $presenter.password1)
            
            if isRegistration {
                SecureField("Повторите пароль", text: $presenter.password2)
                    .textFieldStyle(text: $presenter.password2)
            }
        }
        
    }
    
    var loginButton: some View {
        
        AsyncButton {
            if isRegistration {
                if presenter.checkCurrectData() {
                    sendOnMailCodePresent = 100_000
                }
            } else {
                //await presenter.login()
                
                isPresentHomeView = true
            }
            
//            guard let user = presenter.user else { return }
//
//            mainVM.user = user
            
//            router.showScreen(.fullScreenCover) { _ in
//                HomeView(mainVM: mainVM)
//            }
        } label: { isPerformingAction in
            ZStack {
                 if isPerformingAction {
                       ProgressView()
                 }
                   
                Text(isRegistration ? "Зарегистрироваться" : "Войти")
                    .opacity(isPerformingAction ? 0 : 1)
            }
            .minimumScaleFactor(0.5)
            .font(.system(size: 17))
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.green)
            }
       }
    }
    
    var swapButton: some View {
        Text(isRegistration ? "Войти" : "Регистрация")
            .foregroundColor(Color.init(uiColor: .systemBlue))
            .underline()
            .onTapGesture {
//                Task {
                isRegistration.toggle()
//                    mainVM.user = User.mock
//                    await vm.authService.createAnonymous()
//                    router.showScreen(.fullScreenCover) { _ in
//                        HomeView(mainVM: mainVM)
//                    }
//                }
            }
            .padding(.bottom, 50)
    }
    
    var forgotPassword: some View {
        Text("Забыл пароль")
            .foregroundColor(Color.init(uiColor: .lightGray))
            .underline()
            .onTapGesture {
//                Task {
                    forgotPasswordPresent = true
//                    mainVM.user = User.mock
//                    await vm.authService.createAnonymous()
//                    router.showScreen(.fullScreenCover) { _ in
//                        HomeView(mainVM: mainVM)
//                    }
//                }
            }
            .padding(.bottom, 50)
    }
}
