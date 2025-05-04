//
//  AllTaskRouter.swift
//  LvL-up
//
//  Created by MyBook on 02.05.2025.
//

import SwiftUI

protocol AllTaskRouterProtocol {
    func navigateToEditTask(for task: DailyTask, returnNewTask: @escaping (DailyTask)->Void) -> AnyView
}

final class AllTaskRouter: AllTaskRouterProtocol {
    func navigateToEditTask(for task: DailyTask, returnNewTask: @escaping (DailyTask)->Void) -> AnyView  {
        AnyView(EditTaskView(task: task, returnNewTask: returnNewTask))
    }
}
