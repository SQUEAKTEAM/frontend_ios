//
//  CalendarRouter.swift
//  LvL-up
//
//  Created by MyBook on 04.05.2025.
//

import SwiftUI

protocol CalendarRouterProtocol {
    func navigateToAddTask(returnNewTask: @escaping (DailyTask)->Void) -> AnyView
}

final class CalendarRouter: CalendarRouterProtocol {
    
    func navigateToAddTask(returnNewTask: @escaping (DailyTask)->Void) -> AnyView {
        AnyView(EditTaskView(task: DailyTask.new, returnNewTask: returnNewTask))
    }
}
