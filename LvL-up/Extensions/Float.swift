//
//  Float.swift
//  LvL-up
//
//  Created by MyBook on 22.05.2025.
//

import Foundation

extension Float {
    func convertToString() -> String {
        if self.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", self)
        } else {
            return String(format: "%.2f", self)
        }
    }
}
