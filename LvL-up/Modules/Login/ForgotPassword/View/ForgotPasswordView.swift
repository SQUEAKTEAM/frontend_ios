//
//  ForgotPasswordView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 15.02.2024.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @StateObject var vm = ForgotPasswordViewModel()
    @Binding var isOpen: Bool
    
    var body: some View {
        ForgotPasswordSegment(vm: vm)
            .presentAsBottomSheet($isOpen, maxHeight: 350)
            .onChange(of: vm.state) { state in
                isOpen = state != .closed
            }
            .onChange(of: isOpen) { isOpen in
                if isOpen && vm.state == .closed {
                    vm.changeState()
                }
                if !isOpen {
                    vm.close()
                }
            }
    }
}

#Preview {
    ForgotPasswordView(isOpen: .constant(true))
}
