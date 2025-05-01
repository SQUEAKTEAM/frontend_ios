//
//  ChartCell.swift
//  LvL-up
//
//  Created by MyBook on 01.05.2025.
//

import SwiftUI

struct ChartCell: View {
    var body: some View {
        VStack {
            PieChartView(
                values: [1300, 500, 300],
                names: ["Выполнено", "Почти Выполнено", "Провалено"],
                backgroundColor: Color.background
            )
            .frame(width: 300)
            HStack {
                Text("Выполнено")
                Text("Почти Выполнено")
                Text("Провалено")
            }
            
        }
    }
}

#Preview {
    ChartCell()
}
