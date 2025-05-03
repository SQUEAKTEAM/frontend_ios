//
//  ScheduleView.swift
//  LvL-up
//
//  Created by MyBook on 03.05.2025.
//

import SwiftUI

struct ScheduleView: View {
    var body: some View {
        VStack {
            CalendarView()
            AllTaskView()
        }
    }
}

#Preview {
    ScheduleView()
}
