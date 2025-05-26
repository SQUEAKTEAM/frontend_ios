//
//  TaskCell.swift
//  LvL-up
//
//  Created by MyBook on 09.04.2025.
//

import SwiftUI
import SwiftfulUI

struct TaskCell: View, TaskCellProtocol {
    
    var task: DailyTask
    var isNeedMask: Bool = true
    
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
                            .foregroundStyle(.black)
                            .bold()
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(nil)
                        Spacer()
                        Text("\((isNeedMask ? task.calculateCurrentReward() : String(task.reward))) xp")
                            .foregroundStyle(.black)
                            .font(.title3)
                            .bold()
                            .italic()
                    }
                    
                    HStack {
                        CustomProgressBar(
                            selection: Float(task.checkPoint),
                            range: 0...Float(task.checkPoints),
                            backgroundColor: .secondary,
                            foregroundColor: .green,
                            cornerRadius: 10,
                            height: 10)
                        .mask {
                            HStack(spacing: 1) {
                                ForEach(0..<(isNeedMask ? task.checkPoints : 1), id: \.id) { _ in
                                    Rectangle()
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .foregroundStyle(.primary)
        .listRowBackground(Color.background)
    }
}

#Preview {
    TaskCell(task: DailyTask.mockTasks.first!)
}
