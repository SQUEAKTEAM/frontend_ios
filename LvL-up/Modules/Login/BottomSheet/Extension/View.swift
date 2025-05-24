//
//  View.swift
//  LvL-up
//
//  Created by MyBook on 16.05.2025.
//

import SwiftUI

extension View {
    func presentAsBottomSheet(_ present: Binding<Bool>, maxHeight: CGFloat? = nil, minHeight: CGFloat? = nil, offsetY: CGFloat = .zero, isAllowPresent: Bool = true) -> some View {
        modifier(BottomSheet(bottomSheetShown: present, maxHeight: maxHeight, minHeight: minHeight, offsetY: offsetY, isAllowPresent: isAllowPresent))
    }
}
