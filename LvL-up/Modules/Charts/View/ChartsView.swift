//
//  ChartsView.swift
//  LvL-up
//
//  Created by MyBook on 01.05.2025.
//

import SwiftUI

struct ChartsView: View {
    @StateObject var presenter = ChartsPresenter()
    
    var body: some View {
        VStack {
            charts
            
            LegendView(slices:
                        [LegendItem(name: "Выполнено", color: .green),
                         LegendItem(name: "Почти выполнено", color: .yellow),
                         LegendItem(name: "Провалено", color: .red)])
            
            Spacer()
        }
        .task {
            await presenter.getData()
        }
    }
}

#Preview {
    ChartsView()
}

extension ChartsView {
    var charts: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(presenter.statistics) { stat in
                    ChartCell(title: stat.title, contents: stat.createChartContent())
                }
            }
            .frame(height: 220)
            .padding()
        }
    }
}
