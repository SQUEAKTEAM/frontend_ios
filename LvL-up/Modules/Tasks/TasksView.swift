//
//  TasksView.swift
//  LvL-up
//
//  Created by MyBook on 09.04.2025.
//

import SwiftUI

struct TasksView: View {

    @State private var items = ["Apple", "Banana", "Orange", "Grapes", "Mango"]
    var body: some View {
        VStack {
            MainLvLView()
            List {
                Section("Дневные задания") {
                    ForEach(items, id: \.self) { i in
                        TaskCell()
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    //
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .onDrag {
                                return NSItemProvider(object: i as NSString)
                            }
                    }
                    .onMove { sourceIndices, destinationIndex in
                        items.move(fromOffsets: sourceIndices, toOffset: destinationIndex)
                    }
                }
                Section("Выполнено") {
                    ForEach(items, id: \.self) { i in
                        TaskCell()
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    //
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .onDrag {
                                return NSItemProvider(object: i as NSString)
                            }
                    }
                    .onMove { sourceIndices, destinationIndex in
                        items.move(fromOffsets: sourceIndices, toOffset: destinationIndex)
                    }
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            Spacer()
        }
    }
}

#Preview {
    TasksView()
}
