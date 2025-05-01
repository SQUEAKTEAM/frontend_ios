//
//  LegendView.swift
//  LvL-up
//
//  Created by MyBook on 01.05.2025.
//

import SwiftUI

struct LegendItem {
    let name: String
    let color: Color
}

struct LegendView: View {
    let slices: [LegendItem]
    
    var body: some View {
        HStack {
            ForEach(slices, id: \.name) { slice in
                Circle()
                    .fill(slice.color)
                    .frame(width: 5, height: 5)
                Text(slice.name)
            }
        }
        .font(.caption)
        .bold()
    }
}

#Preview {
    LegendView(slices: [LegendItem(name: "Выполнено", color: .green), LegendItem(name: "Почти выполнено", color: .yellow), LegendItem(name: "Провалено", color: .red)])
}
