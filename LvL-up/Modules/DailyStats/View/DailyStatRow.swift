//
//  DailyStatRow.swift
//  LvL-up
//
//  Created by MyBook on 22.05.2025.
//

import SwiftUI

struct DailyStatRow: View {
    let label: String
    let value: Int
    let color: Color
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text("\(value)")
                .fontWeight(.medium)
                .foregroundColor(color)
        }
    }
}

#Preview {
    DailyStatRow(label: "test", value: 10, color: .green)
}
