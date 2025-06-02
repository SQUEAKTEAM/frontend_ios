//
//  AllTaskCell.swift
//  LvL-up
//
//  Created by MyBook on 16.04.2025.
//

import SwiftUI

struct AllTaskCell: View {
    
    var task: DailyTask
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
            
            HStack {
                Image(systemName: task.img)
                    .resizable()
                    .scaledToFit()
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
                    if !task.category.title.isEmpty {
                        HStack(alignment: .bottom) {
                            Text("Категория:")
                                .font(.caption)
                                .italic()
                            Text(task.category.title)
                                .foregroundStyle(task.getColor())
                                .bold()
                                .italic()
                            Spacer()
                        }
                        .padding(.leading, 5)
                    }
                }
            }
            .foregroundStyle(.black)
            .padding()
        }
        .frame(height: 80)
        .foregroundStyle(.primary)
        .listRowBackground(Color.background)
    }
}

#Preview {
    AllTaskCell(task: DailyTask.mockTasks.first!)
}
