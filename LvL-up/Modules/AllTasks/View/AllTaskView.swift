//
//  AllTaskView.swift
//  LvL-up
//
//  Created by MyBook on 16.04.2025.
//

import SwiftUI

struct AllTaskView: View {
    
    @StateObject var presenter = AllTaskPresenter()
    
    var body: some View {
        List {
            ForEach(presenter.tasks) { task in
                AllTaskCell(task: task)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .none) {
                            withAnimation(.spring) {
                                //presenter.updateCurrentProgress(to: task, checkPoint: task.checkPoint + 1)
                            }
                        } label: {
                            Label("Редактировать", systemImage: "square.and.pencil")
                        }
                        .tint(.yellow)
                    }
                    .onDrag {
                        return NSItemProvider(object: task.id.uuidString as NSString)
                    }
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .task {
            await presenter.getData()
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    AllTaskView()
}
