//
//  ScheduleView.swift
//  LvL-up
//
//  Created by MyBook on 03.05.2025.
//

import SwiftUI

struct ScheduleView: View {
    @StateObject var presenter = SchedulePresenter()
    
    var body: some View {
        VStack {
            CalendarView(selectedDate: $presenter.selectedDate)
            AllTaskView(tasks: $presenter.tasks)
        }
        .task {
            await presenter.getData()
        }
    }
}

#Preview {
    ScheduleView()
}
