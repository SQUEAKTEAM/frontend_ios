//
//  DailyStatsView.swift
//  LvL-up
//
//  Created by MyBook on 21.05.2025.
//

import SwiftUI

struct DailyStatsView: View {
    let failedTasks: Int
    let halfCompletedTasks: Int
    let successfulTasks: Int
    let experience: Int // положительное - получено, отрицательное - потеряно
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            // Заголовок
            Text("Ежедневная статистика")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            // Иконка или аватар
            Image(systemName: experience >= 0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(experience >= 0 ? .green : .red)
            
            // Изменение уровня
            Text(experience >= 0 ? "+\(experience) опыта" : "\(experience) опыта")
                .font(.title3)
                .foregroundColor(experience >= 0 ? .green : .red)
            
            // Статистика задач
            VStack(spacing: 15) {
                StatRow(label: "Провалено:", value: "\(failedTasks)", color: .red)
                StatRow(label: "Почти выполнено:", value: "\(halfCompletedTasks)", color: .yellow)
                StatRow(label: "Успешно:", value: "\(successfulTasks)", color: .green)
            }
            .padding(.horizontal)
            
            // Кнопка закрытия
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
    }
}

// Компонент для строки статистики
struct StatRow: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
                .foregroundColor(color)
        }
    }
}

// Для предпросмотра
#Preview {
    DailyStatsView(
        failedTasks: 3,
        halfCompletedTasks: 2,
        successfulTasks: 5,
        experience: 1
    )
}
