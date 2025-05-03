//
//  AllTaskPresenter.swift
//  LvL-up
//
//  Created by MyBook on 16.04.2025.
//

import Foundation
import SwiftUI

final class AllTaskPresenter: ObservableObject {
    
    private let interactor: TaskInteractorProtocol
    private let router: AllTaskRouterProtocol
    
    @Binding var tasks: [DailyTask]
    
    init(interactor: TaskInteractorProtocol = TaskInteractor(), router: AllTaskRouterProtocol = AllTaskRouter(), tasks: Binding<[DailyTask]>) {
        self.interactor = interactor
        self.router = router
        self._tasks = tasks
    }
    
    @MainActor
    func getData() async {
        tasks = DailyTask.mockTasks
    }
    
    func addNewTask() -> AnyView {
        router.navigateToAddTask()
    }
    
    func editTask(_ task: Taskk) -> AnyView {
        router.navigateToEditTask(for: task)
    }
}
