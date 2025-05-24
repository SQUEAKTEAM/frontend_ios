//
//  ChartCell.swift
//  LvL-up
//
//  Created by MyBook on 01.05.2025.
//

import SwiftUI

struct ChartCell: View {
    var title: String
    var contents: [PieChartContent]
    @State var toggle: Bool = true
    @State var value: Int? = nil
    
    var body: some View {
        ZStack {
            //background 
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.background)
                .shadow(color: .secondary, radius: 1)
            
            content
        }
        .frame(width: 180, height: 220)
    }
}

#Preview {
    ChartCell(title: "Здоровье", contents: [PieChartContent(value: 30, color: .green), PieChartContent(value: 22, color: .yellow), PieChartContent(value: 1, color: .red)])
}

extension ChartCell {
    var content: some View {
        VStack {
            HStack {
                Text(value == nil ? title : String(value!))
                    .lineLimit(1)
                Spacer()
                Image(systemName: "chart.pie.fill")
                    .foregroundStyle(.secondaryText)
            }
            .font(.subheadline)
            .bold()
            
            if contents.total == 0 {
                Circle()
                    .foregroundStyle(.secondaryText)
            } else {
                PieChartView(contents: contents, value: $value)
            }
        }
        .padding(.horizontal)
    }
}
