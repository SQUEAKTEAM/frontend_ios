//
//  DailyStatsView.swift
//  LvL-up
//
//  Created by MyBook on 21.05.2025.
//

import SwiftUI

struct DailyStatsView: View {
    @StateObject private var presenter = DailyStatsPresenter()
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        if let stats = presenter.stats {
            VStack(spacing: 20) {
                Text("Ежедневная статистика")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Image(systemName: stats.reward >= 0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(stats.reward >= 0 ? .green : .red)
                
                Text(stats.reward >= 0 ? "+\(stats.reward.convertToString()) опыта" : "\(stats.reward.convertToString()) опыта")
                    .font(.title3)
                    .foregroundColor(stats.reward >= 0 ? .green : .red)
                
                VStack(spacing: 15) {
                    DailyStatRow(label: "Провалено:", value: stats.countFailure, color: .red)
                    DailyStatRow(label: "Почти выполнено:", value: stats.countMiddle, color: .yellow)
                    DailyStatRow(label: "Успешно:", value: stats.countSuccess, color: .green)
                }
                .padding(.horizontal)
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Закрыть")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding(.vertical)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 5)
        } else {
            ProgressView()
                .task {
                    await presenter.getData()
                }
        }
    }
}

// Для предпросмотра
#Preview {
    DailyStatsView()
}
