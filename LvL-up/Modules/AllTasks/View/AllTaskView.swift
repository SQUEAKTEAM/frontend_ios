//
//  AllTaskView.swift
//  LvL-up
//
//  Created by MyBook on 16.04.2025.
//

import SwiftUI

struct AllTaskView: View {
    
    @StateObject var presenter = AllTaskPresenter()
    @State private var isEditing = false
    
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
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .task {
            await presenter.getData()
        }
        .fullScreenCover(isPresented: $isEditing, content: {
            presenter.addNewTask()
        })
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    AllTaskView()
}
