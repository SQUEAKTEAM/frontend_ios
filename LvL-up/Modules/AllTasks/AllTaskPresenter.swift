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
    
    @Published var tasks: [DailyTask] = []
    
    init(interactor: TaskInteractorProtocol = TaskInteractor(), router: AllTaskRouterProtocol = AllTaskRouter()) {
        self.interactor = interactor
        self.router = router
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
