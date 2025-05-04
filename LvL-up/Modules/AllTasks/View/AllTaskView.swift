//
//  AllTaskView.swift
//  LvL-up
//
//  Created by MyBook on 16.04.2025.
//

import SwiftUI

struct AllTaskView: View {
    @ObservedObject var presenter: AllTaskPresenter
    @State private var isEditing = false
    
    init(tasks: Binding<[DailyTask]>) {
        self._presenter = ObservedObject(initialValue: AllTaskPresenter(tasks: tasks))
    }
    
    var body: some View {
        List {
            ForEach(presenter.tasks) { task in
                AllTaskCell(task: task)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            isEditing = true
                        } label: {
                            Label("Редактировать", systemImage: "square.and.pencil")
                        }
                        .tint(.yellow)
                    }
                    .fullScreenCover(isPresented: $isEditing, content: {
                        presenter.editTask(task)
                    })
            }
            Rectangle()
                .frame(height: 80)
                .foregroundStyle(.clear)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    AllTaskView(tasks: .constant(DailyTask.mockTasks))
}
