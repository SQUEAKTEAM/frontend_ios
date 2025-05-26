//
//  TasksView.swift
//  LvL-up
//
//  Created by MyBook on 09.04.2025.
//

import SwiftUI
import ConfettiSwiftUI

struct TasksView: View {
    @StateObject var presenter = TaskPresenter()
    @State private var trigger: Bool = false
    
    var body: some View {
        VStack {
            MainLvLView(newCurrentExp: $presenter.updateCurrentLvlEx)
            
            List {
                if !presenter.getNoCompletedTasks(false).isEmpty {
                    Section("Задания") {
                        noComplitedContent(isDaily: false)
                    }
                }
                
                if !presenter.getNoCompletedTasks(true).isEmpty {
                    Section("Дневные задания") {
                        noComplitedContent(isDaily: true)
                    }
                }
                if !presenter.completedTask.isEmpty {
                    Section("Выполнено") {
                        complitedContent
                    }
                }
                Rectangle()
                    .frame(height: 80)
                    .foregroundStyle(.clear)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.background)
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            Spacer()
        }
        .task {
            await presenter.getData()
        }
        .confettiCannon(trigger: $trigger, num: 20, confettis: [.text("⭐️")], confettiSize: 20, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
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
                        withAnimation(.spring(duration: 1)) {
                            trigger.toggle()
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
