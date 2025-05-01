//
//  AllTaskCell.swift
//  LvL-up
//
//  Created by MyBook on 16.04.2025.
//

import SwiftUI

struct AllTaskCell: View {
    
    var task: AllDailyTask
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
            
            HStack {
                Image(systemName: task.img)
                    .resizable()
                    .foregroundStyle(.black)
                    .frame(width: 40, height: 40)
                Spacer()
                VStack {
                    HStack {
                        Text(task.title)
                            .bold()
                        Spacer()
                        Text("\(task.reward) xp")
                            .font(.title3)
                            .bold()
                            .italic()
                    }
                    HStack(alignment: .bottom) {
                        Text("Способ получения:")
                            .font(.caption)
                            .italic()
                        Group {
                            switch task.typeProgress {
                            case .manually:
                                Text("Вручную ✋")
                                    .foregroundStyle(.cyan)
                            case .timer:
                                Text("Таймер ⏱️")
                                    .foregroundStyle(.purple)
                            case .appActivity:
                                Text("Приложения 📱")
                                    .foregroundStyle(.blue)
                            }
                        }
                        .bold()
                        .italic()
                        Spacer()
                    }
                    .padding(.leading, 5)
                }
            }
            .foregroundStyle(.black)
            .padding()
        }
        .frame(height: 80)
        .foregroundStyle(.primary)
    }
}

#Preview {
    AllTaskCell(task: AllDailyTask.mockTasks.first!)
}
