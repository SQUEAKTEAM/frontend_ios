//
//  Color.swift
//  LvL-up
//
//  Created by MyBook on 14.04.2025.
//

import SwiftUI

extension Color {
    static let theme = ColorTheme()
    
    // Переопределение стандартных цветов
    static var green: Color { theme.green }
    static var red: Color { theme.red }
    static var black: Color { theme.background }
    static var secondary: Color { theme.secondaryText }
    // Добавьте другие цвета по необходимости
    
    struct ColorTheme {
        let accent = Color("AccentColor")
        let background = Color("BackgroundColor")
        let green = Color("GreenColor")
        let red = Color("RedColor")
        let secondaryText = Color("SecondaryTextColor")
    }
}
