//
//  LoginRouter.swift
//  LvL-up
//
//  Created by MyBook on 21.05.2025.
//

import SwiftUI

protocol LoginRouterProtocol {
    func navigateToHomeScreen() -> AnyView
}

final class LoginRouter: LoginRouterProtocol {
    func navigateToHomeScreen() -> AnyView  {
        AnyView(HomeView())
    }
}
