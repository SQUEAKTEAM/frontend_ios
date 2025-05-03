//
//  AllTaskRouter.swift
//  LvL-up
//
//  Created by MyBook on 02.05.2025.
//

import SwiftUI

protocol AllTaskRouterProtocol {
    func navigateToAddTask() -> AnyView
    func navigateToEditTask(for task: Taskk) -> AnyView
}

final class AllTaskRouter: AllTaskRouterProtocol {
    
    func navigateToAddTask() -> AnyView {
        AnyView(EditTaskView(task: Taskk.new))
    }
    
    func navigateToEditTask(for task: Taskk) -> AnyView  {
        AnyView(EditTaskView(task: task))
    }
}
