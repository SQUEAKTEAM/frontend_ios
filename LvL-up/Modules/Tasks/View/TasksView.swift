//
//  TasksView.swift
//  LvL-up
//
//  Created by MyBook on 09.04.2025.
//

import SwiftUI

struct TasksView: View {
    @StateObject var presenter = TaskPresenter()
    
    var body: some View {
        VStack {
            MainLvLView(newCurrentExp: $presenter.updateCurrentLvlEx)
            
            List {
                Section("Задания") {
                    noComplitedContent(isDaily: false)
                }
                Section("Дневные задания") {
                    noComplitedContent(isDaily: true)
                }
                Section("Выполнено") {
                    complitedContent
                    Rectangle()
                        .frame(height: 80)
                        .foregroundStyle(.clear)
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            Spacer()
        }
        .task {
            await presenter.getData()
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    TasksView()
}

extension TasksView {
    func noComplitedContent(isDaily: Bool) -> some View {
        ForEach(presenter.getNoCompletedTasks(isDaily)) { task in
            TaskCell(task: task)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .none) {
                        withAnimation(.spring) {
                            presenter.updateCurrentProgress(to: task, checkPoint: task.checkPoint + 1)
                        }
                    } label: {
                        Label("Выполнить", systemImage: "checkmark")
                    }
                    .tint(.green)
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button(role: .none) {
                        withAnimation(.spring) {
                            presenter.updateCurrentProgress(to: task, checkPoint: task.checkPoint - 1)
                        }
                    } label: {
                        Label("Отменить", systemImage: "xmark")
                    }
                    .tint(.red)
                }
                .onDrag {
                    return NSItemProvider(object: String(task.id) as NSString)
                }
        }
        .onMove { sourceIndices, destinationIndex in
            presenter.notCompletedTask.move(fromOffsets: sourceIndices, toOffset: destinationIndex)
        }
    }
    
    var complitedContent: some View {
        ForEach(presenter.completedTask) { task in
            TaskCell(task: task)
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button(role: .none) {
                        withAnimation(.spring) {
                            presenter.updateCurrentProgress(to: task, checkPoint: task.checkPoint - 1)
                        }
                    } label: {
                        Label("Отменить", systemImage: "xmark")
                    }
                    .tint(.red)
                }
        }
    }
}
