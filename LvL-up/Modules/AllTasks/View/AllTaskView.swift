//
//  AllTaskView.swift
//  LvL-up
//
//  Created by MyBook on 16.04.2025.
//

import SwiftUI

struct AllTaskView: View {
    @ObservedObject var presenter: AllTaskPresenter
    @State private var editingTask: DailyTask? = nil
    @State private var taskToDelete: DailyTask? = nil
    
    init(tasks: Binding<[DailyTask]>) {
        self._presenter = ObservedObject(initialValue: AllTaskPresenter(tasks: tasks))
    }
    
    var body: some View {
        List {
            tasks(isArchived: false)
            if !presenter.getTasks(true).isEmpty {
                Section("Архив") {
                    tasks(isArchived: true)
                }
            }
            Rectangle()
                .frame(height: 80)
                .foregroundStyle(.clear)
                .listRowSeparator(.hidden)
        }
        .fullScreenCover(item: $editingTask, content: { dailyTask in
            presenter.editTask(dailyTask)
        })
        .alert(item: $taskToDelete) { task in
            Alert(
                title: Text("Вы уверены, что хотите удалить эту задачу?"),
                primaryButton: .destructive(Text("Удалить")) {
                    presenter.deleteTask(task)
                },
                secondaryButton: .cancel()
            )
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    AllTaskView(tasks: .constant(DailyTask.mockTasks))
}

extension AllTaskView {
    func tasks(isArchived: Bool) -> some View {
        ForEach(presenter.getTasks(isArchived)) { task in
            AllTaskCell(task: task)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button {
                        editingTask = task
                    } label: {
                        Label("Редактировать", systemImage: "square.and.pencil")
                    }
                    .tint(.yellow)
                    
                    Button {
                        presenter.archiveTask(task)
                    } label: {
                        Label(isArchived ? "Из архива" : "В архив", systemImage: "archivebox")
                    }
                    .tint(.blue)
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        taskToDelete = task
                    } label: {
                        Label("Удалить", systemImage: "trash")
                    }
                    .tint(.red)
                }
        }
    }
}
