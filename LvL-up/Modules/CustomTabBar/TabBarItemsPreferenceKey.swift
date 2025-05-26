//
//  TabBarItemsPreferenceKey.swift
//  LvL-up
//
//  Created by MyBook on 14.04.2025.
//

import Foundation
import SwiftUI

struct TabBarItemsPreferenceKey: PreferenceKey {
    
    static var defaultValue: [TabBarItem] = []
    
    static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
        value += nextValue()
    }
    
}

struct TabBarItemViewModiferWithOnAppear: ViewModifier {
    
    let tab: TabBarItem
    @Binding var selection: TabBarItem
    
    @ViewBuilder func body(content: Content) -> some View {
        if selection == tab {
            content
                .preference(key: TabBarItemsPreferenceKey.self, value: [tab])
                .transition(.move(edge: .bottom).combined(with: .opacity))
        } else {
            Text("")
                .preference(key: TabBarItemsPreferenceKey.self, value: [tab])
        }
            
    }
    
}

extension View {
    
    func tabBarItem(tab: TabBarItem, selection: Binding<TabBarItem>) -> some View {
        modifier(TabBarItemViewModiferWithOnAppear(tab: tab, selection: selection))
    }
    
}
