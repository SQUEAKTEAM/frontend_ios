//
//  AlertModifier.swift
//  LvL-up
//
//  Created by MyBook on 16.05.2025.
//

import SwiftUI

struct ErrorAlertModifier: ViewModifier {
    @Binding var alertStatus: AlertStatus?
    @State private var isShowingAlert = false
    
    func body(content: Content) -> some View {
        content
            .onChange(of: alertStatus) { status in
                guard status != nil else { return }
                isShowingAlert = true
            }
            .alert(
                alertStatus?.message ?? "",
                isPresented: $isShowingAlert
            ) {
                Button("OK", role: .cancel) {
                    alertStatus = nil
                }
            }
    }
}

extension View {
    func withErrorAlert(
        alertStatus: Binding<AlertStatus?>
    ) -> some View {
        self.modifier(
            ErrorAlertModifier(
                alertStatus: alertStatus
            )
        )
    }
}
